import SwiftUI

struct FocusTimerView: View {
    @StateObject private var viewModel = FocusTimerViewModel()
    private let accentColor = Color(red: 0.0, green: 200.0 / 255.0, blue: 150.0 / 255.0)

    private var formattedTime: String {
        TimeFormatter.format(seconds: viewModel.timeRemaining)
    }

    private var primaryButtonTitle: String {
        if viewModel.sessionCompleted {
            return "Start Again"
        }
        return viewModel.isRunning ? "Pause" : (viewModel.timeRemaining < viewModel.selectedDuration ? "Resume" : "Start Session")
    }

    var body: some View {
        ZStack {
            AmbientView()

            VStack(spacing: 32) {
                PresenceView(presenceCount: viewModel.presenceCount)

                Spacer(minLength: 0)

                Text(formattedTime)
                    .font(.system(size: 72, weight: .medium, design: .monospaced))
                    .tracking(1.2)
                    .foregroundStyle(viewModel.isRunning ? accentColor : .white)
                    .id(formattedTime)
                    .transition(.opacity)

                Spacer(minLength: 0)

                if !viewModel.isRunning {
                    DurationPicker(
                        selectedDuration: Binding(
                            get: { viewModel.selectedDuration },
                            set: { viewModel.updateSelectedDuration($0) }
                        )
                    )
                }

                PrimaryButton(title: primaryButtonTitle) {
                    if viewModel.sessionCompleted {
                        viewModel.reset()
                        viewModel.start()
                        return
                    }

                    if viewModel.isRunning {
                        viewModel.pause()
                    } else {
                        viewModel.start()
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
        }
        .safeAreaInset(edge: .top) {
            HStack {
                Spacer()
                SoundToggleButton(selectedSound: $viewModel.selectedSound) {
                    viewModel.cycleAmbientSound()
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 8)
            .padding(.bottom, 8)
        }
        .overlay {
            if viewModel.sessionCompleted {
                CompletionOverlay {
                    viewModel.reset()
                    viewModel.start()
                }
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
            }
        }
        .animation(.easeInOut, value: viewModel.isRunning)
        .animation(.easeInOut(duration: 0.3), value: viewModel.sessionCompleted)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    FocusTimerView()
        .preferredColorScheme(.dark)
}
