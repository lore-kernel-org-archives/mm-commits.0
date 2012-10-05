From: akpm@linux-foundation.org
Subject: [merged] sections-fix-section-conflicts-in-sound.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:13:38 -0700
Message-ID: <20121005201339.0D05620004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:51306 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932799Ab2JEUNl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:13:41 -0400
Received: by mail-ee0-f74.google.com with SMTP id b57so139472eek.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:13:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: sections: fix section conflicts in sound
has been removed from the -mm tree.  Its filename was
     sections-fix-section-conflicts-in-sound.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: sections: fix section conflicts in sound

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/soc/codecs/wm5100.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN sound/soc/codecs/wm5100.c~sections-fix-section-conflicts-in-sound sound/soc/codecs/wm5100.c
--- a/sound/soc/codecs/wm5100.c~sections-fix-section-conflicts-in-sound
+++ a/sound/soc/codecs/wm5100.c
@@ -1233,7 +1233,7 @@ static const struct snd_soc_dapm_route w
 	{ "PWM2", NULL, "PWM2 Driver" },
 };
 
-static const __devinitdata struct reg_default wm5100_reva_patches[] = {
+static const __devinitconst struct reg_default wm5100_reva_patches[] = {
 	{ WM5100_AUDIO_IF_1_10, 0 },
 	{ WM5100_AUDIO_IF_1_11, 1 },
 	{ WM5100_AUDIO_IF_1_12, 2 },
_

Patches currently in -mm which might be from ak@linux.intel.com are

origin.patch
linux-next.patch
thp-x86-introduce-have_arch_transparent_hugepage.patch
thp-remove-assumptions-on-pgtable_t-type.patch
thp-introduce-pmdp_invalidate.patch
thp-make-madv_hugepage-check-for-mm-def_flags.patch
thp-s390-thp-splitting-backend-for-s390.patch
thp-s390-thp-pagetable-pre-allocation-for-s390.patch
thp-s390-disable-thp-for-kvm-host-on-s390.patch
thp-s390-architecture-backend-for-thp-on-s390.patch

