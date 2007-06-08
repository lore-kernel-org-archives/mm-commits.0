From: akpm@linux-foundation.org
Subject: - yet-another-uniwill-laptop-with-alc861-codec.patch removed from -mm tree
Date: Fri, 08 Jun 2007 10:35:00 -0700
Message-ID: <200706081735.l58HZ09f006337@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47470 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S937116AbXFHRf6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 13:35:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davej@redhat.com, andy@smile.org.ua, perex@suse.cz, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     Yet another Uniwill laptop with ALC861 codec
has been removed from the -mm tree.  Its filename was
     yet-another-uniwill-laptop-with-alc861-codec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Yet another Uniwill laptop with ALC861 codec
From: Dave Jones <davej@redhat.com>

Rediffed version of the patch from ..
http://bugzilla.kernel.org/show_bug.cgi?id=8016
that seems to be lingering for some time.

Original patch by: Andy Shevchenko <andy@smile.org.ua>
Signed-off-by: Dave Jones <davej@redhat.com>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN sound/pci/hda/patch_realtek.c~yet-another-uniwill-laptop-with-alc861-codec sound/pci/hda/patch_realtek.c
--- a/sound/pci/hda/patch_realtek.c~yet-another-uniwill-laptop-with-alc861-codec
+++ a/sound/pci/hda/patch_realtek.c
@@ -9291,6 +9291,7 @@ static struct snd_pci_quirk alc861_cfg_t
 	SND_PCI_QUIRK(0x1179, 0xff00, "Toshiba", ALC861_TOSHIBA),
 	SND_PCI_QUIRK(0x1179, 0xff10, "Toshiba", ALC861_TOSHIBA),
 	SND_PCI_QUIRK(0x1584, 0x9072, "Uniwill m31", ALC861_UNIWILL_M31),
+	SND_PCI_QUIRK(0x1584, 0x9075, "Uniwill", ALC861_UNIWILL_M31),
 	SND_PCI_QUIRK(0x1584, 0x2b01, "Uniwill X40AIx", ALC861_UNIWILL_M31),
 	SND_PCI_QUIRK(0x1849, 0x0660, "Asrock 939SLI32", ALC660_3ST),
 	SND_PCI_QUIRK(0x8086, 0xd600, "Intel", ALC861_3ST),
_

Patches currently in -mm which might be from davej@redhat.com are

document-acked-by.patch
git-alsa.patch
git-agpgart.patch
git-cpufreq.patch
i386-remove-support-for-the-rise-cpu.patch
fix-up-codingstyle-in-isofs.patch
undeprecate-raw-driver.patch
fix-typo-in-prefetchh.patch
