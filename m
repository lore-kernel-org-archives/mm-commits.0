From: akpm@linux-foundation.org
Subject: [merged] drm-intel-add-ignore-lvds-quirk-info-for-aopen-mini-pc.patch removed from -mm tree
Date: Mon, 15 Jun 2009 12:01:31 -0700
Message-ID: <200906151901.n5FJ1V1i022860@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50152 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932415AbZFOTBs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Jun 2009 15:01:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jarod@redhat.com, florian@demmer.org, jbarnes@virtuousgeek.org, mm-commits@vger.kernel.org


The patch titled
     drm: intel: add ignore lvds quirk info for AOpen Mini PC
has been removed from the -mm tree.  Its filename was
     drm-intel-add-ignore-lvds-quirk-info-for-aopen-mini-pc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drm: intel: add ignore lvds quirk info for AOpen Mini PC
From: Jarod Wilson <jarod@redhat.com>

Fix a FIXME in the intel LVDS bring-up code, adding the appropriate
blacklist entry for the AOpen Mini PC, courtesy of a dmidecode dump from
Florian Demmer.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
Cc: Florian Demmer <florian@demmer.org>
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/intel_lvds.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN drivers/gpu/drm/i915/intel_lvds.c~drm-intel-add-ignore-lvds-quirk-info-for-aopen-mini-pc drivers/gpu/drm/i915/intel_lvds.c
--- a/drivers/gpu/drm/i915/intel_lvds.c~drm-intel-add-ignore-lvds-quirk-info-for-aopen-mini-pc
+++ a/drivers/gpu/drm/i915/intel_lvds.c
@@ -420,8 +420,14 @@ static const struct dmi_system_id intel_
 			DMI_MATCH(DMI_PRODUCT_NAME, "Studio Hybrid 140g"),
 		},
 	},
