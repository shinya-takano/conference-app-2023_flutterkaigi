import 'package:conference_2023/l10n/localization.dart';
import 'package:conference_2023/ui/router/router_app.dart';
import 'package:conference_2023/ui/screen/venue/floor_map.dart';
import 'package:conference_2023/ui/screen/venue/location_map.dart';
import 'package:conference_2023/ui/screen/venue/lunch_map.dart';
import 'package:conference_2023/ui/screen/venue/venue_dev_dummy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

enum VenueTab {
  floor,
  location,
  lunch,
}

class VenuePage extends ConsumerWidget {
  const VenuePage({
    super.key,
    required this.type,
  });

  final VenueTab type;

  bool get _isProduction => const String.fromEnvironment('flavor') == 'pro';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = ref.watch(localizationProvider);

    return Column(
      children: [
        const Gap(16),
        SegmentedButton<VenueTab>(
          segments: [
            ButtonSegment(
              icon: const Icon(Icons.layers),
              label: Text(localization.venueFloorMap),
              value: VenueTab.floor,
            ),
            ButtonSegment(
              icon: const Icon(Icons.location_on),
              label: Text(localization.venueLocationMap),
              value: VenueTab.location,
            ),
            ButtonSegment(
              icon: const Icon(Icons.restaurant),
              label: Text(localization.venueLunchMap),
              value: VenueTab.lunch,
            ),
          ],
          selected: {
            type,
          },
          onSelectionChanged: (value) {
            VenueRoute(
              tab: value.first,
            ).go(context);
          },
          showSelectedIcon: false,
        ),
        const Gap(8),
        Expanded(
          child: switch (type) {
            VenueTab.floor => const FloorMapPage(),
            VenueTab.location =>
              _isProduction ? const LocationMapPage() : const VenueDevDummy(),
            VenueTab.lunch =>
              _isProduction ? const LaunchMapPage() : const VenueDevDummy(),
          },
        ),
      ],
    );
  }
}
