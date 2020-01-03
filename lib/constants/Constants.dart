/*
 * Copyright 2019 mybytecode
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
class Config {

  static const String gAppName = "Sports Fantasy";

  static const String gBaseUrl = "http://lokshahinews.com";

  //Name the categories which will be displayed on tabBar
  static const List gCategoriesNamesTab = [
    "Home",
    "Bollywood",
    "Business",
    "Entertainment"
  ];

  //Name of Tabs as you have added on wordpress and with the sequence of above list of tab names
  static const List gCategoriesId = ["", 156, 143, 142];

  static const gOneSignalAppId = "40c46587-61df-419c-8c51-19eec9ebd5d5";
}
