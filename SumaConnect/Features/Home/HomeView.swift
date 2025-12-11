//
//  HomeView.swift
//  SumaConnect
//
//  Created by Alberto Orrantia on 09/12/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var session: SessionViewModel
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
            ZStack {
                Color.Suma.darkGray
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    SumaHeaderView()

                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 24) {
                            greetingSection
                            integrationsListSection
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 24)
                        .padding(.bottom, 32)
                    }
                }
            }
            .task {
                await viewModel.loadIntegrations()
            }
        }

    // MARK: - Helper Views
        private var greetingSection: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text("Hola 👋, \(session.userName ?? "Charlie Friend")")
                    .font(.title3.bold())
                    .foregroundColor(Color.Suma.darkBlue)

                Text("Aquí puedes ver y administrar las apps conectadas a Suma Connect.")
                    .font(.subheadline)
                    .foregroundColor(Color.Suma.darkBlue.opacity(0.8))
            }
        }

        private var integrationsListSection: some View {
            VStack(alignment: .leading, spacing: 16) {
                Text("Tus integraciones")
                    .font(.headline)
                    .foregroundColor(Color.Suma.darkBlue)

                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 20)
                        .tint(Color.Suma.darkBlue)
                } else {
                    VStack(spacing: 12) {
                        ForEach(viewModel.integrations) { integration in
                            IntegrationRowView(integration: integration)
                        }
                    }
                }
            }
        }
    }


// TBD: init OAuth & view detail will be handled and managed on the viewmodel, post MVP
private struct IntegrationRowView: View {
        let integration: HomeIntegration
        private let badgeWidth: CGFloat = 110

        var body: some View {
            Button {
                print("\(integration.name) tapped")
            } label: {
                HStack(alignment: .top, spacing: 12) {
                    
                    ZStack {
                        Circle()
                            .fill(Color.Suma.red)
                            .frame(width: 40, height: 40)

                        Text(String(integration.name.prefix(1)))
                            .font(.headline)
                            .foregroundColor(.white)
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        HStack(alignment: .firstTextBaseline) {
                            Text(integration.name)
                                .font(.subheadline.bold())
                                .foregroundColor(Color.Suma.darkBlue)

                            Spacer()

                            Text(integration.statusText)
                                .font(.caption.bold())
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .frame(width: badgeWidth, alignment: .center)
                                .background(integration.statusColor.opacity(0.15))
                                .foregroundColor(integration.statusColor)
                                .clipShape(Capsule())
                        }

                        Text(integration.description)
                            .font(.footnote)
                            .foregroundColor(Color.Suma.darkBlue.opacity(0.85))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color.Suma.darkBlue.opacity(0.5))
                }
                .padding(12)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
            }
            .buttonStyle(.plain)
        }
}

#Preview {
    HomeView()
        .environmentObject(SessionViewModel(userId: "demo", userName: "Demo User"))
}
