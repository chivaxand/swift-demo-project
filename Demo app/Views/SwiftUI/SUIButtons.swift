import SwiftUI


// https://www.swiftyplace.com/blog/mastering-swiftui-buttons-a-comprehensive-guide-to-creating-and-customizing-buttons

struct SUIButtons: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Text tap")
                    .onTapGesture {
                        print("action")
                    }
                
                Button("Simple") {
                    print("action")
                }
                
                Button {
                    print("action")
                } label: {
                    Label("Add", systemImage: "plus")
                }
                
                Button {
                    print("action")
                } label: {
                    Image("phone-icon")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 50)
                }
                
                Button(role: .destructive) {
                } label: {
                    Label("destructive", systemImage: "trash")
                }
                
                Button(role: .cancel) {
                } label: {
                    Label("cancel", systemImage: "plus.circle")
                }
                
                Menu("menu") {
                    Button {
                    } label: {
                        Label("default", systemImage: "plus")
                    }
                    Button(role: .destructive) {
                    } label: {
                        Label("destructive", systemImage: "trash")
                    }
                }
                
                Button("bordered", action: {
                    print("action")
                })
                .buttonStyle(.bordered)
                
                Button("borderedProminent", action: {
                    print("action")
                })
                .buttonStyle(.borderedProminent)
                
                Button("borderedProminent", action: {
                    print("action")
                })
                .buttonStyle(.plain)
                
                Button("capsule", action: {
                    print("action")
                })
                .controlSize(.regular)
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
                
                Button("roundedRectangle", action: {
                    print("action")
                })
                .controlSize(.regular)
                .buttonStyle(.bordered)
                .buttonBorderShape(.roundedRectangle(radius: 12))
                
                Button("roundedRectangle", action: {
                    print("action")
                })
                .controlSize(.regular)
                .buttonStyle(.bordered)
                .buttonBorderShape(.roundedRectangle)
                
                Button("automatic", action: {
                    print("action")
                })
                .controlSize(.regular)
                .buttonStyle(.bordered)
                .buttonBorderShape(.automatic)
                
                Button("capsule", action: {
                    print("action")
                })
                .buttonStyle(.bordered)
                .tint(.red)
                
                Button {
                    print("action")
                } label: {
                    Text("Sign Up")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .padding(.vertical, 0)
                
                Button {
                    print("action")
                } label: {
                    Text("Log In")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
                .padding(.vertical, 0)
                
                Button("Custom style", action: {
                    print("action")
                })
                .buttonStyle(CustomButtonStyle())
                
                Button("Custom style", action: {
                    print("action")
                })
                .buttonStyle(RedWhiteButtonStyle())
                
                Button("Custom style", action: {
                    print("action")
                })
                .buttonStyle(BlueWhiteButtonStyle2())
            }
            .padding(.horizontal, 32)
        }
    }
}

fileprivate struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        let gradient =  Gradient(colors: [Color.blue, Color.green])
        let accentGradient = LinearGradient(gradient: gradient,
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing)
        configuration.label
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .foregroundColor(.white)
            .opacity(configuration.isPressed ? 0.8 : 1)
            // .background(Color.cyan)
            // .cornerRadius(6)
            .background(accentGradient
                .clipShape(.rect(cornerRadius: 12))
                .shadow(radius: configuration.isPressed ? 5 : 10))
    }
}

fileprivate struct RedWhiteButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        let cornerRadius = 6.0
        let color: Color = .red
        configuration.label
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .foregroundColor(color)
            .background(configuration.isPressed ? color.opacity(0.2) : .white)
            .clipShape(.rect(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(.red, lineWidth: 1)
            )
            .opacity(configuration.isPressed ? 0.7 : 1)
    }
}

fileprivate struct BlueWhiteButtonStyle2: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        let color: Color = .cyan
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .stroke(color, lineWidth: 1)
                .background(configuration.isPressed ? color.opacity(0.2) : .white)
            
            configuration.label
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .foregroundColor(color)
        }
        .opacity(configuration.isPressed ? 0.8 : 1)
    }
}

#Preview {
    SUIButtons()
}
