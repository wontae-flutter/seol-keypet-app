import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:go_router/go_router.dart";

import 'dart:developer' as developer;
import "../../../providers/provider_pet.dart";
import 'tabs/tabs_pet.dart';

class PetTabsScreen extends ConsumerStatefulWidget {
  // final String pid;
  const PetTabsScreen({
    super.key,
    // required this.pid,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PetTabsScreenState();
}

class _PetTabsScreenState extends ConsumerState<PetTabsScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    String pid = arguments["pid"];
    final pet = ref.watch(petProvider(pid));
    developer.log("Pet with ${pid}", name: "CurrentPet");

    return pet.when(
      loading: () => Scaffold(
        body: Center(),
      ),
      error: (error, stackTrace) =>
          Scaffold(body: Center(child: Text("펫 정보를 가져오지 못했습니다. 다시 시도해 주세요."))),
      data: (data) => Scaffold(
        appBar: AppBar(
          shape: Border(bottom: BorderSide(color: Colors.black26)),
          title: Text("펫 프로필"),
          // actions: [IconButton(onPressed: () {}, icon: Icon(Icons.settings))],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 1.0,
                  color: Colors.black26,
                ),
                TabBar(
                  indicatorColor: Colors.black,
                  labelColor: Colors.black,
                  controller: _tabController,
                  tabs: [
                    Tab(
                      text: "홈",
                    ),
                    Tab(
                      text: "리포트",
                    ),
                    Tab(
                      text: "접종 관리",
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            // PetInfoTab(pid: widget.pid, pet: data!),
            // VaccineCardTab(pid: widget.pid, pet: data),
            // VaccineHistoryTab(pid: widget.pid, pet: data),
            PetInfoTab(pid: pid, pet: data!),
            VaccineCardTab(pid: pid, pet: data),
            VaccineHistoryTab(pid: pid, pet: data),
          ],
        ),
      ),
    );
  }
}
