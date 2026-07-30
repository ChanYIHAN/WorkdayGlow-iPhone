import SwiftUI

struct CreativeTemplateBackground: View {
    let template: WidgetTemplateKind

    var body: some View {
        switch template {
        case .controlDeck:
            LinearGradient(
                colors: [Color("GlowCanvas"), Color("PlumInk")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .shortcutStack:
            LinearGradient(
                colors: [Color("GalleryCanvas"), Color("SkyGlow").opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .focusConsole:
            LinearGradient(
                colors: [Color("PlumInk"), Color("AuroraLavender").opacity(0.78)],
                startPoint: .top,
                endPoint: .bottomTrailing
            )
        case .photoPolaroid:
            LinearGradient(
                colors: [Color("SoftCream"), Color("RoseGlow").opacity(0.24)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .photoFilmstrip:
            LinearGradient(
                colors: [Color("GlowCanvas"), Color.black],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .photoMosaic:
            LinearGradient(
                colors: [Color("GalleryCanvas"), Color("ButterGlow").opacity(0.28)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .musicVinyl:
            LinearGradient(
                colors: [Color("GlowCanvas"), Color("PlumInk")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .musicGlass:
            LinearGradient(
                colors: [Color("AuroraLavender"), Color("SkyGlow"), Color("SeaGlass")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .musicWave:
            LinearGradient(
                colors: [Color("SoftCream"), Color("ButterGlow").opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        default:
            Color("GalleryCanvas")
        }
    }
}

struct CreativeTemplateArtwork: View {
    let template: WidgetTemplateKind
    let size: WidgetArtworkSize

    var body: some View {
        Group {
            switch template {
            case .controlDeck:
                controlDeck
            case .shortcutStack:
                shortcutStack
            case .focusConsole:
                focusConsole
            case .photoPolaroid:
                photoPolaroid
            case .photoFilmstrip:
                photoFilmstrip
            case .photoMosaic:
                photoMosaic
            case .musicVinyl:
                musicVinyl
            case .musicGlass:
                musicGlass
            case .musicWave:
                musicWave
            default:
                EmptyView()
            }
        }
        .accessibilityElement(children: .contain)
    }

    private var controlDeck: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("快捷控制")
                        .font(.headline)
                        .fontWeight(.black)
                    Text("SHORTCUT CONSOLE")
                        .font(.system(size: 8, weight: .bold))
                        .tracking(1.6)
                        .foregroundStyle(.white.opacity(0.38))
                }
                Spacer()
                Image(systemName: "command")
                    .foregroundStyle(Color("SeaGlass"))
            }

            HStack(spacing: 9) {
                toolTile("wifi", "Wi-Fi", Color("SkyGlow"))
                toolTile("point.3.connected.trianglepath.dotted", "蓝牙", Color("AuroraLavender"))
                toolTile("antenna.radiowaves.left.and.right", "蜂窝", Color("SeaGlass"))
                toolTile("airplane", "飞行", Color("AuroraCoral"))
            }
        }
        .padding(17)
        .foregroundStyle(.white)
    }

    private var shortcutStack: some View {
        VStack(alignment: .leading, spacing: 11) {
            HStack {
                Image(systemName: "bolt.fill")
                    .foregroundStyle(Color("AuroraCoral"))
                Text("QUICK SWITCH")
                    .font(.system(size: 9, weight: .black))
                    .tracking(1.4)
                Spacer()
            }

            Spacer(minLength: 0)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                compactTool("wifi", Color("SkyGlow"))
                compactTool("point.3.connected.trianglepath.dotted", Color("AuroraLavender"))
                compactTool("antenna.radiowaves.left.and.right", Color("SeaGlass"))
                compactTool("airplane", Color("AuroraCoral"))
            }
        }
        .padding(15)
        .foregroundStyle(Color("PlumInk"))
    }

    private var focusConsole: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "moon.stars.fill")
                    .foregroundStyle(Color("ButterGlow"))
                Spacer()
                Text("21:30")
                    .font(.caption2)
                    .monospacedDigit()
                    .foregroundStyle(.white.opacity(0.45))
            }

            Spacer()

            Text("安静一会儿")
                .font(size == .small ? .title3 : .title2)
                .fontWeight(.black)
            Text("飞行模式 · 专注 · 离线")
                .font(.caption2)
                .foregroundStyle(.white.opacity(0.52))

            HStack(spacing: 6) {
                focusChip("airplane")
                focusChip("moon.fill")
                focusChip("bell.slash.fill")
            }
        }
        .padding(16)
        .foregroundStyle(.white)
    }

    private var photoPolaroid: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5, style: .continuous)
                .fill(Color.white)
                .rotationEffect(.degrees(-2))
                .padding(12)
                .shadow(color: Color("PlumInk").opacity(0.12), radius: 9, y: 5)

            VStack(spacing: 6) {
                samplePhoto(seed: 0)
                    .clipShape(RoundedRectangle(cornerRadius: 3, style: .continuous))
                HStack {
                    Text("SUMMER MEMORY")
                        .font(.system(size: 8, weight: .black))
                        .tracking(1)
                    Spacer()
                    Image(systemName: "heart.fill")
                        .font(.caption2)
                        .foregroundStyle(Color("RoseGlow"))
                }
            }
            .padding(size == .small ? 19 : 20)
            .foregroundStyle(Color("PlumInk"))
        }
    }

    private var photoFilmstrip: some View {
        HStack(spacing: 9) {
            filmFrame(seed: 0)
            filmFrame(seed: 1)
            filmFrame(seed: 2)
        }
        .padding(.horizontal, 18)
        .overlay(alignment: .topLeading) {
            Text("NO. 07  ·  MOMENTS")
                .font(.system(size: 8, weight: .bold))
                .tracking(1.3)
                .foregroundStyle(.white.opacity(0.55))
                .padding(13)
        }
    }

    private var photoMosaic: some View {
        HStack(spacing: 7) {
            samplePhoto(seed: 0)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

            VStack(spacing: 7) {
                samplePhoto(seed: 1)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                samplePhoto(seed: 2)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
            .frame(width: size == .large ? 120 : 92)
        }
        .padding(12)
        .overlay(alignment: .bottomLeading) {
            Text("私人画廊  ·  三个好瞬间")
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .padding(.horizontal, 19)
                .padding(.vertical, 17)
                .shadow(radius: 4)
        }
    }

    private var musicVinyl: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("NOW SPINNING")
                    .font(.system(size: 8, weight: .black))
                    .tracking(1.5)
                    .foregroundStyle(.white.opacity(0.42))
                Spacer()
                Image(systemName: "music.note")
                    .foregroundStyle(Color("SeaGlass"))
            }

            Spacer()

            ZStack {
                Circle()
                    .fill(Color.black.opacity(0.75))
                ForEach([0.82, 0.62, 0.42], id: \.self) { scale in
                    Circle()
                        .stroke(Color.white.opacity(0.12), lineWidth: 1)
                        .scaleEffect(scale)
                }
                Circle()
                    .fill(Color("RoseGlow"))
                    .frame(width: 35, height: 35)
                Circle()
                    .fill(Color("GlowCanvas"))
                    .frame(width: 7, height: 7)
            }
            .frame(width: 84, height: 84)

            Text("Midnight Drive")
                .font(.caption)
                .fontWeight(.bold)
                .lineLimit(1)
            Text("YOUR DAILY MIX")
                .font(.system(size: 8, weight: .semibold))
                .tracking(1)
                .foregroundStyle(.white.opacity(0.4))
        }
        .padding(15)
        .foregroundStyle(.white)
    }

    private var musicGlass: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(Color.white.opacity(0.28))
                Image(systemName: "music.quarternote.3")
                    .font(.system(size: 36))
                    .foregroundStyle(.white)
            }
            .frame(width: 104, height: 104)

            VStack(alignment: .leading, spacing: 5) {
                Text("正在播放")
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.58))
                Text("Cloud Nine")
                    .font(.title3)
                    .fontWeight(.black)
                Text("Aurora Radio")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.58))

                HStack(spacing: 15) {
                    Image(systemName: "backward.fill")
                    Image(systemName: "play.fill")
                        .padding(9)
                        .background(.white, in: Circle())
                        .foregroundStyle(Color("PlumInk"))
                    Image(systemName: "forward.fill")
                }
                .font(.caption)
                .padding(.top, 5)
            }

            Spacer(minLength: 0)
        }
        .padding(17)
        .foregroundStyle(.white)
    }

    private var musicWave: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "waveform")
                    .foregroundStyle(Color("RoseGlow"))
                Spacer()
                Image(systemName: "play.fill")
                    .font(.caption)
                    .padding(8)
                    .background(Color("PlumInk"), in: Circle())
                    .foregroundStyle(.white)
            }

            Spacer()

            Text("慢慢喜欢你")
                .font(.headline)
                .fontWeight(.black)
                .lineLimit(1)
            Text("今日歌单")
                .font(.caption2)
                .foregroundStyle(.secondary)
            HStack(alignment: .center, spacing: 3) {
                ForEach(0..<16, id: \.self) { index in
                    Capsule()
                        .fill(index < 6 ? Color("RoseGlow") : Color("PlumInk").opacity(0.16))
                        .frame(height: CGFloat(5 + ((index * 7) % 18)))
                }
            }
            .frame(height: 24)
        }
        .padding(15)
        .foregroundStyle(Color("PlumInk"))
    }

    private func toolTile(_ symbol: String, _ label: String, _ tint: Color) -> some View {
        VStack(spacing: 7) {
            Image(systemName: symbol)
                .font(.headline)
                .foregroundStyle(tint)
                .frame(width: 33, height: 33)
                .background(tint.opacity(0.14), in: Circle())
            Text(label)
                .font(.system(size: 9, weight: .bold))
                .foregroundStyle(.white.opacity(0.64))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color.white.opacity(0.07), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private func compactTool(_ symbol: String, _ tint: Color) -> some View {
        Image(systemName: symbol)
            .font(.headline)
            .foregroundStyle(tint)
            .frame(maxWidth: .infinity)
            .frame(height: 39)
            .background(Color.white.opacity(0.68), in: RoundedRectangle(cornerRadius: 13, style: .continuous))
    }

    private func focusChip(_ symbol: String) -> some View {
        Image(systemName: symbol)
            .font(.caption2)
            .frame(width: 29, height: 29)
            .background(Color.white.opacity(0.1), in: Circle())
    }

    private func filmFrame(seed: Int) -> some View {
        VStack(spacing: 4) {
            HStack(spacing: 4) {
                ForEach(0..<4, id: \.self) { _ in
                    Capsule()
                        .fill(Color.white.opacity(0.35))
                        .frame(height: 3)
                }
            }
            samplePhoto(seed: seed)
                .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
            HStack(spacing: 4) {
                ForEach(0..<4, id: \.self) { _ in
                    Capsule()
                        .fill(Color.white.opacity(0.35))
                        .frame(height: 3)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }

    private func samplePhoto(seed: Int) -> some View {
        ZStack {
            LinearGradient(
                colors: sampleColors(seed),
                startPoint: seed == 1 ? .top : .topLeading,
                endPoint: .bottomTrailing
            )
            Circle()
                .fill(Color.white.opacity(0.24))
                .frame(width: seed == 2 ? 70 : 104, height: seed == 2 ? 70 : 104)
                .blur(radius: 4)
                .offset(x: seed == 1 ? 30 : -28, y: seed == 2 ? -18 : 25)
            Image(systemName: seed == 1 ? "cloud.sun.fill" : "camera.aperture")
                .font(seed == 1 ? .title : .title2)
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.white.opacity(0.72))
        }
    }

    private func sampleColors(_ seed: Int) -> [Color] {
        switch seed {
        case 1:
            [Color("SkyGlow"), Color("AuroraLavender")]
        case 2:
            [Color("ButterGlow"), Color("RoseGlow")]
        default:
            [Color("SeaGlass"), Color("SkyGlow"), Color("AuroraLavender")]
        }
    }
}
