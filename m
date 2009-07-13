From: akpm@linux-foundation.org
Subject: + maintainers-remove-ivtv-user-lists-add-cx18-url.patch added to -mm tree
Date: Mon, 13 Jul 2009 14:57:03 -0700
Message-ID: <200907132157.n6DLv3h1018672@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45069 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756937AbZGMV5h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Jul 2009 17:57:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com


The patch titled
     MAINTAINERS: Remove ivtv-user lists, add CX18 url
has been added to the -mm tree.  Its filename is
     maintainers-remove-ivtv-user-lists-add-cx18-url.patch

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
Subject: MAINTAINERS: Remove ivtv-user lists, add CX18 url
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN MAINTAINERS~maintainers-remove-ivtv-user-lists-add-cx18-url MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-ivtv-user-lists-add-cx18-url
+++ a/MAINTAINERS
@@ -1725,10 +1725,10 @@ M:	hverkuil@xs4all.nl
 P:	Andy Walls
 M:	awalls@radix.net
 L:	ivtv-devel@ivtvdriver.org
-L:	ivtv-users@ivtvdriver.org
 L:	linux-media@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 W:	http://linuxtv.org
+W:	http://www.ivtvdriver.org/index.php/Cx18
 S:	Maintained
 F:	Documentation/video4linux/cx18.txt
 F:	drivers/media/video/cx18/
@@ -3289,7 +3289,6 @@ IVTV VIDEO4LINUX DRIVER
 P:	Hans Verkuil
 M:	hverkuil@xs4all.nl
 L:	ivtv-devel@ivtvdriver.org
-L:	ivtv-users@ivtvdriver.org
 L:	linux-media@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 W:	http://www.ivtvdriver.org
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

