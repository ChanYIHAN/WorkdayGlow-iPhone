// Migration helper: retain all existing identifiers while creating the editable design manifest.
import fs from 'node:fs';
const read = p => fs.readFileSync(p, 'utf8').replace(/\r\n/g, '\n');
const old = JSON.parse(read('content/expansion-150.json'));
const added = JSON.parse(read('content/additions-200.json'));
fs.writeFileSync('content/expansion-200.json', JSON.stringify([...old, ...added], null, 2) + '\n');
const catalog = read('Shared/Sources/WidgetTemplateCatalog.swift');
const ids = catalog.split('enum WidgetTemplateKind:')[1].split('    var id:')[0].match(/case (\w+)/g).map(x => x.slice(5)).slice(0, 100);
const titleSwitch = catalog.split('    var title: String {')[3].split('    var subtitle:')[0];
const baseTitles = new Map([...titleSwitch.matchAll(/case \.(\w+): "([^"]+)"/g)].map(x => [x[1], x[2]]));
const oldExpansion = [...read('Shared/Sources/ExpansionTemplateCatalog.swift').matchAll(/case \.(\w+):\n\s+item\("([^"]+)", "([^"]+)", \.(\w+), "([^"]+)", \.(\w+), (\d+)\)/g)].map(x => [x[1],x[2],x[3],x[4],x[5],x[6]]);
const expanded = new Map([...oldExpansion, ...old, ...added].map(x => [x[0], x]));
const baseGroups = {
  countdown: ['workdayRail','minimalCountdown','afterworkPlan'], income: ['incomeBento','paydayCalendar'], rhythm: ['weekRhythm','progressOrbit'],
  health: ['healthBento','sleepRibbon','oxygenPulse','stepOrbit','activeBento','recoveryArc'], weather: ['weatherNow','weatherHourly','weatherMinimal'],
  love: ['loveDays','loveOrbit'], time: ['editorialClock','worldClock','calendarClock'], tools: ['controlDeck','shortcutStack','focusConsole'],
  photos: ['photoPolaroid','photoFilmstrip','photoMosaic'], music: ['musicVinyl','musicGlass','musicWave'],
  finance: ['currencyMinimal','currencyMatrix','travelConverter','goldSpot','goldTrend','metalsDuo','stockQuote','watchlistBento','dualMarket'],
  planner: ['glassAgenda','weekPlanner','focusNow'], daily: ['dailyQuote','moonPhase','solarRhythm']
};
const values = {
  workdayRail:'00:42:18', minimalCountdown:'42 分钟', incomeBento:'¥386.40', weekRhythm:'星期五', progressOrbit:'工作 78%', paydayCalendar:'10 月 25 日', afterworkPlan:'去看晚霞',
  healthBento:'68 bpm', sleepRibbon:'7 小时 20 分', oxygenPulse:'98%', weatherNow:'23°', weatherHourly:'午后转晴', weatherMinimal:'晴 · 23°', loveDays:'520 天',loveOrbit:'还有 19 天',
  editorialClock:'09:41',worldClock:'上海 · 09:41',calendarClock:'10 月 02 日',controlDeck:'常用 4 项',shortcutStack:'轻松连接',focusConsole:'专注 25 分',photoPolaroid:'某个晴天',photoFilmstrip:'FRAME 012',photoMosaic:'我们的日常',
  musicVinyl:'SIDE A',musicGlass:'Quiet Morning',musicWave:'03:28',currencyMinimal:'7.12',currencyMatrix:'USD / EUR',travelConverter:'¥712.00',goldSpot:'$2,380',goldTrend:'+1.28%',metalsDuo:'Au / Ag',stockQuote:'$189.42',watchlistBento:'3 只自选',dualMarket:'HK / US',
  stepOrbit:'7,480 步',activeBento:'4.8 km',recoveryArc:'舒缓的一天',glassAgenda:'今天 3 件事',weekPlanner:'一周重点',focusNow:'25 分钟',dailyQuote:'慢慢来，也很好',moonPhase:'上弦月',solarRhythm:'06:12 → 18:08',
  hydrationBloom:'1,250 mL',stressBalance:'放松一下',standRhythm:'8 个小时',mindfulMinutes:'12 分钟',cycleWellness:'温柔照顾自己',heartZones:'有氧 · 128',sleepStages:'深睡 1h 42m',
  airQuality:'AQI 42',rainRadar:'降雨概率 40%',sunriseForecast:'日出 06:12',weeklyWeather:'23° / 16°',pollenCare:'花粉 · 较低',couplePhoto:'一起 520 天',loveLetters:'把喜欢说给你听',nextDate:'还有 3 天',
  flipClock:'09 : 41',wordClock:'九点四十一分',focusClock:'25 分钟',countdownEvent:'还有 21 天',timezoneStrip:'SHA / LON',batteryPanel:'82%',storageMeter:'剩余 44 GB',qrLauncher:'扫一扫',quickNotes:'记住这三件事',appLauncher:'常用 4 项',
  photoStack:'片刻收藏',memoryDate:'那年今日',panoramicPhoto:'远方的山',scrapbook:'October diary',albumShelf:'3 张专辑',lyricsCard:'把今天写成一首歌',nowPlayingMinimal:'Quiet Morning',playlistCover:'晚间漫步',
  cryptoPair:'BTC / ETH',portfolioPulse:'¥12,680',marketHeatmap:'涨 6 / 跌 3',budgetRing:'剩余 ¥2,840',savingsGoal:'¥12,800',expenseSnapshot:'今日 ¥86',habitTracker:'5 / 7 天',pomodoroBoard:'第 3 轮',taskPriority:'重要 2 件',meetingCountdown:'14:00 开始',monthOverview:'October',studyPlan:'今天读 20 页',projectMilestone:'完成 68%',
  affirmation:'你已经在往前走',gratitudePrompt:'今天感谢谁？',zodiacDay:'保持好奇',festivalCountdown:'还有 18 天',vacationCountdown:'还有 16 天',weekendCountdown:'还有 42 分',salaryProgress:'¥6,180',overtimeEarnings:'¥96.00',yearProgress:'今年 75%'
};
const categoryProfiles = {
  countdown: ['AFTER HOURS','为今晚留一点期待',[['下班','18:30'],['剩余','42 分'],['今晚','散步']],0.78],
  income: ['WORK & VALUE','工作价值 · 本地估算',[['今日','¥386'],['时薪','¥48'],['发薪','25 日']],0.61],
  rhythm: ['TIME IN MOTION','在时间里找到自己的节奏',[['本周','第 40 周'],['本月','10 月'],['今年','75%']],0.75],
  health: ['CARE & RECOVER','温和记录，认真休息',[['步数','7,480'],['睡眠','7h 20m'],['活动','386 kcal']],0.68],
  weather: ['SKY JOURNAL','出门前，看看今天的天空',[['湿度','56%'],['风向','东北风'],['高低温','23° / 16°']],0.4],
  love: ['TOGETHER','收藏我们一起度过的日子',[['相伴','520 天'],['周年','10 / 21'],['见面','3 天后']],0.82],
  time: ['THE PRESENT','此刻值得一眼看清',[['上海','09:41'],['伦敦','02:41'],['纽约','21:41']],0.4],
  tools: ['DAILY ESSENTIALS','让常用入口更容易找到',[['入口','4 项'],['电量','82%'],['便签','3 条']],0.82],
  photos: ['PRIVATE GALLERY','一段光影，一点记忆',[['日期','10 / 02'],['收藏','12 张'],['地点','秋日公园']],0.5],
  music: ['LISTEN SLOWLY','为今天留一首背景音乐',[['专辑','Morning'],['曲目','03:28'],['收藏','SIDE A']],0.46],
  finance: ['PERSONAL LEDGER','有序阅读 · 示例参考',[['预算','¥5,000'],['可用','¥2,840'],['已用','43%']],0.43],
  planner: ['MAKE ROOM','给重要的事留出空间',[['今天','3 件事'],['完成','2 件'],['专注','25 分']],0.67],
  daily: ['SMALL RITUALS','普通的日子，也值得收藏',[['时刻','09:41'],['心情','平静'],['留白','10 分钟']],0.5],
  learning: ['KEEP LEARNING','每天一点，记得更久',[['词库','40 词'],['今日','10 词'],['已学','12 词']],0.3]
};
const specificRows = {
  sleepStages:[['深睡','1h 42m'],['核心睡眠','4h 18m'],['快速眼动','1h 20m']],
  hydrationBloom:[['已饮','1,250 mL'],['目标','2,000 mL'],['还差','750 mL']],
  waterSchedule:[['上午','08:00'],['午后','12:00'],['傍晚','16:00']],
  breathingGuide:[['吸气','4 秒'],['呼气','6 秒'],['提醒','放松肩膀']],
  eyeRest:[['工作','20 分钟'],['望远','20 秒'],['休息','放松眼睛']],
  stressBalance:[['提醒','放松肩膀'],['休息','散步 10 分'],['节奏','慢一点']],
  heartZones:[['热身','90–110'],['有氧','110–140'],['恢复','低强度']],
  batteryPanel:[['当前','82%'],['状态','未充电'],['来源','示例数据']],batteryDial:[['当前','82%'],['状态','未充电'],['来源','示例数据']],
  storageMeter:[['容量','128 GB'],['已用','84 GB'],['可用','44 GB']],
  controlDeck:[['连接','Wi-Fi'],['设备','蓝牙'],['模式','专注']],appLauncher:[['工作','便签'],['出门','地图'],['放松','音乐']],shortcutRosette:[['记录','便签'],['出门','地图'],['休息','音乐']],
  quickNotes:[['买花','周五下班'],['还书','周日之前'],['散步','晚饭后']],noteReceipt:[['买花','下班后'],['还书','周日'],['散步','晚饭后']],
  wordRoots:[['re-','再次'],['build','构建'],['rebuild','重新构建']],wordSynonyms:[['calm','内心平静'],['quiet','环境安静'],['still','没有运动']],wordPhrase:[['take a break','休息一下'],['slow down','慢下来'],['keep going','继续前进']],
  wordReview:[['curious','好奇的'],['resilient','有韧性的'],['breathe','呼吸']],wordTravel:[['Where is…?','在哪里？'],['How much?','多少钱？'],['Thank you.','谢谢']],wordWork:[['follow up','跟进'],['deadline','截止日期'],['agenda','议程']],
  packingList:[['证件','护照'],['随身','充电器'],['衣物','薄外套']],todayThree:[['09:30','完成提案'],['14:00','出去走走'],['20:00','阅读 20 页']],
  taskPriority:[['重要','完成方案'],['紧急','回复邮件'],['稍后','整理桌面']],weeklyReflection:[['收获','学会一个新词'],['值得','一次散步'],['下周','早点睡']],
  budgetLedger:[['预算','¥5,000'],['已花','¥2,160'],['可用','¥2,840']],expenseSnapshot:[['今天','¥86'],['本周','¥620'],['本月','¥2,160']],
  albumShelf:[['Morning','轻音乐'],['Dusk','爵士'],['Wander','民谣']],
  littlePromise:[['晚饭','一起做'],['周末','一起散步'],['约定','认真倾听']],sleepRitual:[['准备','放下手机'],['环境','调暗灯光'],['节奏','缓缓呼吸']],
  dayItinerary:[['09:30','方案确认'],['14:00','公园散步'],['19:30','晚间阅读']],weekendRoute:[['第一站','咖啡店'],['第二站','公园'],['第三站','书店']],
  cityWishlist:[['京都','小巷'],['大理','湖边'],['杭州','茶园']],lyricsCard:[['摘录','把今天写成一首歌'],['收藏','个人文字'],['类型','手动内容']]
};
const palettes = {
  mineral:['#F0F5F1','#DDEBE5','#173D34','#287B67','#486157'],
  ink:['#202B3A','#303B50','#F4F2EA','#A8CFC3','#BFC6CF'],
  paper:['#FAF5E9','#ECE1CB','#453D30','#967139','#6B5D48'],
  rose:['#FAEFED','#EDDAD8','#57383A','#A55B68','#705658'],
  sky:['#EFF4FA','#DDE6F3','#30445F','#567DAD','#52647B'],
  dusk:['#30283B','#483D52','#F6EFF3','#D9B4C8','#CDC0CC']
};
Object.assign(specificRows, {
  goldSpot:[['品种','黄金'],['计价','USD / oz'],['变动','+1.28%']],goldTrend:[['开盘','$2,350'],['最高','$2,395'],['最新','$2,380']],metalsDuo:[['黄金','$2,380'],['白银','$28.40'],['单位','USD / oz']],
  currencyMinimal:[['基准','1 USD'],['兑换','7.12 CNY'],['来源','示例汇率']],currencyMatrix:[['美元','7.12'],['欧元','7.88'],['英镑','9.35']],travelConverter:[['金额','100 USD'],['汇率','7.12'],['结果','712 CNY']],exchangeTicket:[['出发','100 USD'],['汇率','7.12'],['到达','712 CNY']],
  stockQuote:[['最新','$189.42'],['变动','+1.28%'],['市场','US']],watchlistBento:[['AAPL','$189.42'],['MSFT','$420.10'],['0700','HK$410']],dualMarket:[['港股','HK$410'],['美股','$189.42'],['状态','示例行情']],cryptoPair:[['BTC','$64,200'],['ETH','$2,650'],['变动','+1.28%']],portfolioPulse:[['资产','¥12,680'],['本月','+1.28%'],['持仓','3 项']],marketHeatmap:[['上涨','6 只'],['下跌','3 只'],['平盘','1 只']],marketRibbon:[['最新','$189.42'],['开盘','$187.00'],['变动','+1.28%']],
  budgetRing:[['预算','¥5,000'],['已用','¥2,160'],['剩余','¥2,840']],savingsGoal:[['目标','¥20,000'],['已存','¥12,800'],['进度','64%']],savingsConstellation:[['目标','¥20,000'],['已存','¥12,800'],['进度','64%']],tripBudget:[['交通','¥80'],['餐饮','¥120'],['其他','¥80']],
  sleepRibbon:[['入睡','23:10'],['醒来','06:30'],['时长','7h 20m']],sleepMoon:[['入睡','23:10'],['醒来','06:30'],['时长','7h 20m']],oxygenPulse:[['血氧','98%'],['时间','09:30'],['来源','示例数据']],pulseRibbon:[['心率','68 bpm'],['低值','58 bpm'],['高值','92 bpm']],
  stepOrbit:[['步数','7,480'],['目标','10,000'],['距离','4.8 km']],activeBento:[['距离','4.8 km'],['步数','7,480'],['活跃','32 分']],walkMap:[['距离','4.8 km'],['时间','48 分'],['路线','河岸散步']],activityReceipt:[['步数','7,480'],['距离','4.8 km'],['活跃','32 分']],standRhythm:[['站立','8 小时'],['目标','12 小时'],['提醒','每小时起身']],mindfulMinutes:[['练习','12 分钟'],['方式','自然呼吸'],['环境','安静角落']],
  cycleWellness:[['记录','个人周期'],['照顾','温热饮水'],['提醒','好好休息']],stretchBreak:[['肩颈','30 秒'],['手腕','30 秒'],['背部','30 秒']],walkInvitation:[['时间','15 分钟'],['地点','附近公园'],['准备','穿舒适的鞋']],moodJournal:[['今天','平静'],['记录','一件小事'],['照顾','留一点空白']],digitalSunset:[['截止','22:30'],['准备','手机放远'],['放松','读一页书']],recoveryArc:[['节奏','低强度'],['休息','散步 10 分'],['提醒','不用赶时间']],recoveryGarden:[['节奏','恢复日'],['活动','轻松散步'],['睡眠','规律作息']],
  airQuality:[['AQI','42'],['级别','优'],['提示','适宜散步']],pollenCare:[['浓度','较低'],['时段','上午'],['提示','留意个人感受']],rainRadar:[['概率','40%'],['时段','14:00'],['准备','带一把伞']],rainRibbon:[['概率','40%'],['时段','14:00'],['准备','带一把伞']],sunriseForecast:[['日出','06:12'],['日落','18:08'],['白昼','11h 56m']],weeklyWeather:[['周五','23° 晴'],['周六','21° 阴'],['周日','20° 小雨']],windCompass:[['风向','东北'],['风力','3 级'],['阵风','18 km/h']],weatherTicket:[['温度','23°'],['降雨','40%'],['随身','一把伞']],
  incomeBento:[['今日','¥386.40'],['本月','¥6,180'],['时薪','¥48']],incomeLedger:[['今日','¥386.40'],['本月','¥6,180'],['时薪','¥48']],hourlyValue:[['时薪','¥48'],['工作','8 小时'],['今天','¥384']],overtimeEarnings:[['加班','2 小时'],['时薪','¥48'],['合计','¥96']],salaryProgress:[['目标','¥8,000'],['累计','¥6,180'],['完成','77%']],paydayCalendar:[['发薪','10 / 25'],['剩余','23 天'],['周期','每月']],paydayTicket:[['发薪','10 / 25'],['剩余','23 天'],['周期','每月']],
  vacationCountdown:[['出发','10 / 18'],['剩余','16 天'],['目的地','海边']],holidayWindow:[['出发','10 / 18'],['剩余','16 天'],['期待','一片海']],afterworkPlan:[['下班','18:30'],['晚霞','18:08'],['计划','河边散步']],departureTicket:[['下班','18:30'],['剩余','42 分'],['今晚','散步']],eveningHorizon:[['剩余','42 分'],['计划','看晚霞'],['日落','18:08']],
  weekRhythm:[['今天','周五'],['周末','2 天'],['重点','完成提案']],weekDots:[['今天','周五'],['本周','5 / 7'],['周末','留给自己']],yearProgress:[['今年','75%'],['剩余','90 天'],['年份','2026']],seasonCompass:[['季节','秋'],['进度','52%'],['提醒','添一件外套']],monthRibbon:[['今天','02 日'],['本月','31 天'],['月份','October']],
  focusClock:[['一轮','25 分'],['休息','5 分'],['模式','专注']],focusNow:[['一轮','25 分'],['休息','5 分'],['目标','完成草稿']],focusConsole:[['工作','25 分'],['休息','5 分'],['通知','稍后处理']],focusDial:[['一轮','25 分'],['休息','5 分'],['目标','完成草稿']],pomodoroBoard:[['当前','第 3 轮'],['工作','25 分'],['休息','5 分']],deepWork:[['时间','50 分'],['任务','撰写方案'],['环境','勿扰']],meetingCountdown:[['开始','14:00'],['地点','会议室 A'],['准备','方案稿']],countdownEvent:[['日期','10 / 23'],['剩余','21 天'],['事件','重要的日子']],flightBoard:[['航班','MU 5101'],['出发','SHA 08:00'],['到达','PEK 10:15']],jetlagClock:[['当地','UTC +8'],['目的地','UTC +1'],['时差','7 小时']],
  habitTracker:[['坚持','5 / 7 天'],['习惯','睡前阅读'],['今天','已完成']],habitConstellation:[['坚持','5 / 7 天'],['习惯','睡前阅读'],['今天','已完成']],readingGoal:[['已读','42 页'],['全书','240 页'],['目标','每天 20 页']],studyPlan:[['目标','20 页'],['时段','20:00'],['书签','第 42 页']],projectMilestone:[['完成','68%'],['当前','界面设计'],['下一步','联调']],skillJourney:[['练习','第 12 次'],['目标','30 次'],['技能','英文阅读']],commutePlan:[['出发','08:20'],['方式','地铁'],['到达','09:00']],ideaInbox:[['想法','做一本小册'],['标签','创作'],['下一步','写下目录']],deadlineRail:[['交付','周五'],['任务','完成方案'],['下一步','检查细节']],homeReset:[['桌面','3 分钟'],['收纳','4 分钟'],['清理','3 分钟']],
  gratitudePrompt:[['谢谢','认真倾听的人'],['记下','一件暖心小事'],['行动','发出感谢']],teaReceipt:[['时间','10 分钟'],['茶饮','乌龙茶'],['准备','放下手机']],coffeeMoment:[['杯数','1 杯'],['时刻','午后'],['片刻','停下来看看窗外']],moonPhase:[['月相','上弦月'],['亮面','50%'],['观察','暮色之后']],moonConstellation:[['月相','上弦月'],['亮面','50%'],['观察','暮色之后']],solarRhythm:[['日出','06:12'],['日落','18:08'],['白昼','11h 56m']],festivalCountdown:[['节日','中秋'],['剩余','18 天'],['愿望','一起团圆']],
  wordDaily:[['单词','serendipity'],['词义','意外的美好发现'],['词性','n.']],wordFlip:[['单词','resilient'],['词义','有韧性的'],['动作','回想后翻面']],wordTicket:[['单词','intentional'],['词义','有意识的'],['词性','adj.']],wordProgress:[['词库','40 词'],['已学','12 词'],['完成','30%']],wordGoal:[['今日目标','10 词'],['已学','4 词'],['剩余','6 词']],wordStreak:[['连续','7 天'],['今日','已练习'],['下次','明天']],wordSpelling:[['提示','充满好奇的'],['字母','7 个'],['答案','curious']],wordListening:[['单词','breathe'],['词义','呼吸'],['跟读','慢慢读一遍']],wordIELTS:[['单词','perspective'],['词义','视角'],['词性','n.']],wordCET:[['单词','essential'],['词义','必要的'],['词性','adj.']],wordMistakes:[['curious','好奇的'],['essential','必要的'],['perspective','视角']],examSprint:[['考试','21 天后'],['每日','10 词'],['今天','开始复习']],languagePassport:[['站点','第 1 站'],['语言','English'],['目标','保持练习']],readingNote:[['摘记','保持好奇'],['页码','42'],['下一步','读 20 页']],readingEditorial:[['今天','20 页'],['书签','第 42 页'],['摘记','保持好奇']],wordExample:[['句子','Stay curious.'],['译意','保持好奇。'],['关键词','curious']]
});
const progressOverrides = { hydrationBloom:0.625, batteryPanel:0.82, batteryDial:0.82, storageMeter:84/128, salaryProgress:6180/8000, savingsGoal:0.64, savingsConstellation:0.64, budgetRing:0.568, stepOrbit:0.748, habitTracker:5/7, habitConstellation:5/7, yearProgress:0.75, seasonCompass:0.52, monthRibbon:2/31, readingGoal:42/240, projectMilestone:0.68, wordProgress:0.3, wordGoal:0.4, packingList:0.5 };
const themeByCategory = {countdown:'ink',income:'paper',rhythm:'mineral',health:'mineral',weather:'sky',love:'rose',time:'ink',tools:'mineral',photos:'paper',music:'dusk',finance:'paper',planner:'sky',daily:'paper',learning:'mineral'};
const layoutOverrides = {
  workdayRail:'ticket',minimalCountdown:'editorial',incomeBento:'bento',weekRhythm:'constellation',progressOrbit:'orbit',paydayCalendar:'ticket',afterworkPlan:'editorial',
  healthBento:'bento',sleepRibbon:'waveform',oxygenPulse:'orbit',weatherNow:'mosaic',weatherHourly:'timeline',weatherMinimal:'editorial',loveDays:'editorial',loveOrbit:'orbit',
  editorialClock:'editorial',worldClock:'ticket',calendarClock:'constellation',controlDeck:'bento',shortcutStack:'list',focusConsole:'dial',photoPolaroid:'mosaic',photoFilmstrip:'ticket',photoMosaic:'mosaic',musicVinyl:'dial',musicGlass:'bento',musicWave:'waveform',
  currencyMinimal:'editorial',currencyMatrix:'bento',travelConverter:'ticket',goldSpot:'editorial',goldTrend:'waveform',metalsDuo:'bento',stockQuote:'waveform',watchlistBento:'list',dualMarket:'bento',stepOrbit:'orbit',activeBento:'bento',recoveryArc:'orbit',glassAgenda:'list',weekPlanner:'timeline',focusNow:'dial',dailyQuote:'editorial',moonPhase:'dial',solarRhythm:'timeline',
  hydrationBloom:'orbit',stressBalance:'dial',heartZones:'waveform',sleepStages:'timeline',cycleWellness:'editorial',rainRadar:'waveform',couplePhoto:'mosaic',loveLetters:'editorial',flipClock:'ticket',wordClock:'editorial',timezoneStrip:'ticket',batteryPanel:'dial',qrLauncher:'mosaic',photoStack:'mosaic',memoryDate:'ticket',panoramicPhoto:'mosaic',scrapbook:'mosaic',albumShelf:'mosaic',lyricsCard:'editorial',nowPlayingMinimal:'waveform',playlistCover:'mosaic',marketHeatmap:'constellation',habitTracker:'constellation',monthOverview:'constellation',affirmation:'editorial',gratitudePrompt:'editorial',wordExample:'editorial',wordRoots:'bento',wordSpelling:'editorial',wordListening:'waveform',wordStreak:'constellation',readingNote:'editorial',languagePassport:'ticket'
};
const rationale = {orbit:'双环突出比例，辅助数值沿侧栏排列',bento:'主数据占双倍权重，辅助数据保持独立小格',timeline:'时间从左到右展开，保留七个清晰刻度',poster:'以一个大字信息为中心，保留充分呼吸空间',gauge:'主数值与进度带对应，端点明确',list:'三条真实场景信息以细分隔对齐',dial:'细刻度圆盘与中心信息形成稳定视觉焦点',ticket:'左右信息以虚线票缝区分，脚注保持小字',constellation:'有序点阵表达积累与分布，避免堆叠数字',waveform:'柔和线形与数值保持上下层次',mosaic:'三个不等面积窗格形成有节奏的构图',editorial:'衬线大字、短句与细横线形成编辑部排版'};
const rows = [...ids, ...old.map(x=>x[0]), ...added.map(x=>x[0])].map(id => {
  const extra = expanded.get(id);
  const category = extra?.[3] ?? Object.entries(baseGroups).find(([,group])=>group.includes(id))[0];
  const title = baseTitles.get(id) ?? extra[1];
  const subtitle = extra?.[2] ?? [...catalog.split('    var subtitle: String {')[1].split('    var category:')[0].matchAll(/case \.(\w+): "([^"]+)"/g)].find(x=>x[1]===id)?.[2] ?? title;
  const [eyebrow, defaultCaption, metrics, progress] = categoryProfiles[category];
  const caption = subtitle;
  const layout = layoutOverrides[id] ?? extra?.[5] ?? 'poster';
  const theme = themeByCategory[category];
  const actualRows = specificRows[id] ?? metrics;
  const value = values[id] ?? extra?.[6] ?? title;
  return {id,title,category,subtitle,layout,theme,palette:palettes[theme],eyebrow,value,caption,metrics:actualRows.map(([label,value])=>({label,value})),rows:actualRows.map(([label,value])=>({label,value})),progress:progressOverrides[id]??progress,secondaryProgress:0.46,series:category==='music'?[0.32,0.62,0.92,0.52,0.78,0.4,0.64]:category==='weather'?[0.18,0.32,0.64,0.8,0.48,0.25,0.16]:[0.32,0.48,0.42,0.66,0.58,0.75,0.68],reviewNote:`${title}：${rationale[layout]}；${defaultCaption}。`};
});
if (rows.length!==200 || new Set(rows.map(x=>x.id)).size!==200) throw Error('Invalid catalog migration');
fs.writeFileSync('content/designs.json',JSON.stringify(rows,null,2)+'\n');
console.log('Prepared 200 individually addressable design records.');
