#!/bin/bash

echo "Running Workout Tracker Tests"
echo "=============================="

echo ""
echo "1. Running Unit Tests..."
flutter test test/models_test.dart

echo ""
echo "2. Running Widget Tests..."
flutter test test/widget_test.dart

echo ""
echo "3. Running Integration Tests..."
flutter test integration_test/app_test.dart

echo ""
echo "All tests completed!"
