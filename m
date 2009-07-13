From: akpm@linux-foundation.org
Subject: + maintainers-move-arpd-to-credits.patch added to -mm tree
Date: Mon, 13 Jul 2009 14:57:12 -0700
Message-ID: <200907132157.n6DLvD6s018895@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52627 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757504AbZGMV5q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Jul 2009 17:57:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com


The patch titled
     MAINTAINERS: Move ARPD to CREDITS
has been added to the -mm tree.  Its filename is
     maintainers-move-arpd-to-credits.patch

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
Subject: MAINTAINERS: Move ARPD to CREDITS
From: Joe Perches <joe@perches.com>

Jonathan Layes is hard to find.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 CREDITS     |    3 +++
 MAINTAINERS |    6 ------
 2 files changed, 3 insertions(+), 6 deletions(-)

diff -puN CREDITS~maintainers-move-arpd-to-credits CREDITS
--- a/CREDITS~maintainers-move-arpd-to-credits
+++ a/CREDITS
@@ -2006,6 +2006,9 @@ E: paul@laufernet.com
 D: Soundblaster driver fixes, ISAPnP quirk
 S: California, USA
 
+N: Jonathan Layes
+D: ARPD support
+
 N: Tom Lees
 E: tom@lpsg.demon.co.uk
 W: http://www.lpsg.demon.co.uk/
diff -puN MAINTAINERS~maintainers-move-arpd-to-credits MAINTAINERS
--- a/MAINTAINERS~maintainers-move-arpd-to-credits
+++ a/MAINTAINERS
@@ -955,12 +955,6 @@ W:	http://www.arm.linux.org.uk/
 S:	Maintained
 F:	arch/arm/vfp/
 
-ARPD SUPPORT
-P:	Jonathan Layes
-L:	netdev@vger.kernel.org
-S:	Maintained
-F:	net/ipv4/arp.c
-
 ASUS ACPI EXTRAS DRIVER
 P:	Corentin Chary
 M:	corentincj@iksaif.net
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

