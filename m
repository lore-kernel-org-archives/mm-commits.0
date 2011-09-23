From: akpm@google.com
Subject: + hp_accel-add-axis-mapping-for-hp-probook-elitebook.patch added to -mm tree
Date: Fri, 23 Sep 2011 14:17:43 -0700
Message-ID: <201109232117.p8NLHhG3015482@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:37844 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab1IWVRu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Sep 2011 17:17:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tiwai@suse.de, mjg@redhat.com


The patch titled
     Subject: hp_accel: Add axis-mapping for HP ProBook / EliteBook
has been added to the -mm tree.  Its filename is
     hp_accel-add-axis-mapping-for-hp-probook-elitebook.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Takashi Iwai <tiwai@suse.de>
Subject: hp_accel: Add axis-mapping for HP ProBook / EliteBook

Add the corrected axis-mapping for some HP laptops.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 drivers/platform/x86/hp_accel.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/platform/x86/hp_accel.c~hp_accel-add-axis-mapping-for-hp-probook-elitebook drivers/platform/x86/hp_accel.c
--- a/drivers/platform/x86/hp_accel.c~hp_accel-add-axis-mapping-for-hp-probook-elitebook
+++ a/drivers/platform/x86/hp_accel.c
@@ -229,6 +229,10 @@ static struct dmi_system_id lis3lv02d_dm
 	AXIS_DMI_MATCH("HPB522x", "HP ProBook 522", xy_swap),
 	AXIS_DMI_MATCH("HPB532x", "HP ProBook 532", y_inverted),
 	AXIS_DMI_MATCH("Mini510x", "HP Mini 510", xy_rotated_left_usd),
+	AXIS_DMI_MATCH("HPB63xx", "HP ProBook 63", xy_swap),
+	AXIS_DMI_MATCH("HPB64xx", "HP ProBook 64", xy_swap),
+	AXIS_DMI_MATCH("HPB64xx", "HP EliteBook 84", xy_swap),
+	AXIS_DMI_MATCH("HPB65xx", "HP ProBook 65", x_inverted),
 	{ NULL, }
 /* Laptop models without axis info (yet):
  * "NC6910" "HP Compaq 6910"
_
Subject: Subject: hp_accel: Add axis-mapping for HP ProBook / EliteBook

Patches currently in -mm which might be from tiwai@suse.de are

origin.patch
linux-next.patch
hp_accel-add-a-new-pnp-id.patch
hp_accel-add-axis-mapping-for-hp-probook-elitebook.patch

