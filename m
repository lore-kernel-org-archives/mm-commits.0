From: akpm@linux-foundation.org
Subject: + maintainers-remove-cs461x-sound-card-section.patch added to -mm tree
Date: Mon, 13 Jul 2009 14:57:23 -0700
Message-ID: <200907132157.n6DLvNa5019199@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52526 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757569AbZGMV54 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Jul 2009 17:57:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com


The patch titled
     MAINTAINERS: Remove CS461x sound card section
has been added to the -mm tree.  Its filename is
     maintainers-remove-cs461x-sound-card-section.patch

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
Subject: MAINTAINERS: Remove CS461x sound card section
From: Joe Perches <joe@perches.com>

Thomas Woller's email address bounces
Nils Faerber isn't active

Added Thomas Woller to CREDITS, Nils already has an entry

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 CREDITS     |    3 +++
 MAINTAINERS |    9 ---------
 2 files changed, 3 insertions(+), 9 deletions(-)

diff -puN CREDITS~maintainers-remove-cs461x-sound-card-section CREDITS
--- a/CREDITS~maintainers-remove-cs461x-sound-card-section
+++ a/CREDITS
@@ -3805,6 +3805,9 @@ S: van Bronckhorststraat 12
 S: 2612 XV Delft
 S: The Netherlands
 
+N: Thomas Woller
+D: CS461x Cirrus Logic sound driver
+
 N: David Woodhouse
 E: dwmw2@infradead.org
 D: JFFS2 file system, Memory Technology Device subsystem,
diff -puN MAINTAINERS~maintainers-remove-cs461x-sound-card-section MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-cs461x-sound-card-section
+++ a/MAINTAINERS
@@ -1512,15 +1512,6 @@ L:	alsa-devel@alsa-project.org (moderate
 S:	Supported
 F:	sound/soc/codecs/cs4270*
 
-CIRRUS LOGIC CS4280/CS461x SOUNDDRIVER
-P:	Cirrus Logic Corporation (kernel 2.2 driver)
-M:	Cirrus Logic Corporation, Thomas Woller <twoller@crystal.cirrus.com>
-P:	Nils Faerber (port to kernel 2.4)
-M:	Nils Faerber <nils@kernelconcepts.de>
-S:	Maintained
-F:	Documentation/input/cs461x.txt
-F:	sound/pci/cs46xx/
-
 CLK API
 P:	Russell King
 M:	linux@arm.linux.org.uk
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
mmc-msm_sdccc-driver-for-htc-dream.patch
msm_sdccc-convert-printkkern_level-to-pr_level.patch
msm_sdccc-stylistic-cleaning.patch
msm_sdccc-move-overly-indented-code-to-separate-function.patch
maintainers-ia64-pair-p-m-entries-properly.patch
maintainers-remove-ivtv-user-lists-add-cx18-url.patch
maintainers-qlge-10gb-ethernet-pair-p-m-entries-properly.patch
maintainers-use-tabs-in-acer-aspire-one.patch
maintainers-remove-l-linux-kernel-vgerkernelorg.patch
maintainers-move-arpd-to-credits.patch
maintainers-update-kernel-janitors.patch
maintainers-add-pps-patterns.patch
maintainers-usb-serial-digi-acceleport-use-separate-p-for-al-borchers.patch
maintainers-input-add-dmitrys-name-to-his-email-address.patch
maintainers-remove-cs461x-sound-card-section.patch
maintainers-qlogic-qla2xxx-add-andrew-vasquez-email-address.patch
maintainers-qlogic-qla3xxx-add-ron-mercer-email-address.patch
maintainers-scott-murray-is-no-longer-with-somanetworks.patch
scripts-get_maintainerpl-add-f-directory-use.patch
get_maintainerpl-add-git-min-percent-option.patch

