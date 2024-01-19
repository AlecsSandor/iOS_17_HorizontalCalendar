//
//  ContentView.swift
//  HorizontalCalendar
//
//  Created by Alex on 12/29/23.
//

import SwiftUI

struct CalendarView: View {
    
    // Initializing the View Model which is holding all the functionalities and data for this View
    @StateObject private var viewModel = CalendarViewModel()
    
    // Keeping track of where is the scroll currently
    @State private var scrollPosition: CGPoint = .zero
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    ScrollViewReader { scrollView in
                        HStack(alignment: .top, spacing: 0) {
                            ForEach(viewModel.daysInterval.indices, id: \.self) { index in
                                // The following two HStacks should be abstractized, sorry for leaving them here, but I wanted to have it all on the same page
                                if index == viewModel.selectedIndex {
                                    // The styling for the selected position - the red one
                                    HStack(alignment: .top) {
                                        VStack() {
                                            Text("\(viewModel.daysInterval[index])")
                                                .font(.custom("Poppins-Medium", size: 41, relativeTo: .caption))
                                                .foregroundColor(Color("themeWhite"))
                                                .rotationEffect(.degrees(270))
                                                .lineLimit(1)
                                                .frame(height: 80)
                                                .padding(.top, 20)
                                            Spacer()
                                                .frame(height: 10)
                                            Text(index+1 > 9 ? String(index+1) : "0" + String(index+1))
                                                .font(.custom("Poppins-Medium", size: 42, relativeTo: .caption))
                                                .foregroundColor(Color("themeWhite"))
                                                .padding(.bottom, 20)
                                        }
                                        .frame(width: 95)
                                        
                                        Rectangle()
                                            .fill(.clear)
                                            .frame(width: 1, height: 150)
                                            .padding(.horizontal, 1)
                                    }
                                    .background(Color("themeRed"))
                                    .id(index+1)
                                    
                                } else {
                                    // The styling for the unselected positions
                                    HStack(alignment: .top) {
                                        VStack() {
                                            Text("\(viewModel.daysInterval[index])")
                                                .font(.custom("Poppins-Light", size: 25, relativeTo: .caption))
                                                .foregroundColor(Color("themeDarkGreen"))
                                                .rotationEffect(.degrees(270))
                                                .lineLimit(1)
                                                .frame(height: 60)
                                                .padding(.top, 30)
                                            Spacer()
                                                .frame(height: 5)
                                            Text(index+1 > 9 ? String(index+1) : "0" + String(index+1))
                                                .font(.custom("Poppins-Light", size: 25, relativeTo: .caption))
                                                .foregroundColor(Color("themeDarkGreen"))
                                                .padding(.bottom, 0)
                                        }
                                        .frame(width: 60)
                                        
                                        Rectangle()
                                            .fill(Color("themeGray"))
                                            .frame(width: 1, height: 150)
                                            .padding(.horizontal, 1)
                                    }
                                    .background(.clear)
                                    .id(index+1)
                                }
                            }
                            Spacer()
                                .frame(width: UIScreen.main.bounds.width - 70, height: 150)
                                .background(Color("themeExtraLightGray"))
                                .padding(.leading, 20)
                        }
                        
                        // Notify when the ScrollView is ready, in order to select the initial position of the scroll ( initial day )
                        .onAppear {
                            viewModel.isScrollViewReady = true
                        }
                        .onChange(of: viewModel.isScrollViewReady) {
                            // setting an initial day to display
                            viewModel.selectedDate.day = 10
                            if viewModel.isScrollViewReady {
                                scrollView.scrollTo(viewModel.selectedDate.day, anchor: .leading)
                            }
                        }
                        .scrollTargetLayout()
                        
                        // In order to shift the selected red bbox to the margin of the screen I used geometry reader to always keep it there
                        .background(GeometryReader { geometry in
                            Color.clear
                                .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll")).origin)
                            
                        })
                        
                        // Updating the selected index (day) when a scroll event happends
                        .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                            viewModel.updateSelectedIndex(scrollPosition: value)
                        }
                    }
                }
                .coordinateSpace(name: "scroll")
                .scrollTargetBehavior(.viewAligned)
                
                // Calling the numberOfDays func, when the view appears, to compute the number of days for the current month
                .onAppear() {
                    viewModel.numberOfDays(in: viewModel.selectedDate.month, year: viewModel.selectedDate.year)
                }
                
                // Trigger the haptic feedback on day change
                .onChange(of: viewModel.selectedDate) {
                    impactFeedback(style: .light)
                }
            }
        }
    }

    // A function responsable for managing the haptic effects when the scroll view scrolls
    func impactFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle) {
            let generator = UIImpactFeedbackGenerator(style: style)
            generator.impactOccurred()
    }
}

// Trackes the scroll offset within the scroll view and notifies the parent view about this information during the layout pass.
struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
    }
}


#Preview {
    CalendarView()
}
