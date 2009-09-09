From: akpm@linux-foundation.org
Subject: + maintainers-add-atheros-linux-wireless-drivers-home-page.patch added to -mm tree
Date: Tue, 08 Sep 2009 23:17:23 -0700
Message-ID: <200909090617.n896HNPv028595@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49102 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751726AbZIIGRh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2009 02:17:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, linville@tuxdriver.com, mcgrof@gmail.com


The patch titled
     MAINTAINERS: add Atheros Linux wireless drivers home page
has been added to the -mm tree.  Its filename is
     maintainers-add-atheros-linux-wireless-drivers-home-page.patch

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
Subject: MAINTAINERS: add Atheros Linux wireless drivers home page
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

diff -puN MAINTAINERS~maintainers-add-atheros-linux-wireless-drivers-home-page MAINTAINERS
--- a/MAINTAINERS~maintainers-add-atheros-linux-wireless-drivers-home-page
+++ a/MAINTAINERS
@@ -922,6 +922,7 @@ M:	"Luis R. Rodriguez" <lrodriguez@ather
 M:	Bob Copeland <me@bobcopeland.com>
 L:	linux-wireless@vger.kernel.org
 L:	ath5k-devel@lists.ath5k.org
+W:	http://wireless.kernel.org/en/users/Drivers/ath5k
 S:	Maintained
 F:	drivers/net/wireless/ath/ath5k/
 
@@ -933,6 +934,7 @@ M:	Vasanthakumar Thiagarajan <vasanth@at
 M:	Senthil Balasubramanian <senthilkumar@atheros.com>
 L:	linux-wireless@vger.kernel.org
 L:	ath9k-devel@lists.ath9k.org
+W:	http://wireless.kernel.org/en/users/Drivers/ath9k
 S:	Supported
 F:	drivers/net/wireless/ath/ath9k/
 
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
maintainers-add-atheros-linux-wireless-drivers-home-page.patch
maintainers-add-ipvs-include-files.patch
scripts-get_maintainerpl-add-git-blame.patch
scripts-get_maintainerpl-add-sections-in-pattern-match-depth-order.patch
scripts-get_maintainerpl-add-pattern-depth.patch
scripts-get_maintainerpl-better-email-routines-use-perl-not-shell-where-possible.patch
scripts-get_maintainerpl-add-mailmap-use-shell-and-email-cleanups.patch
scripts-get_maintainerpl-using-separator-implies-nomultiline.patch
scripts-get_maintainerpl-add-remove-duplicates.patch
scripts-get_maintainerpl-add-maintainers-in-order-listed-in-matched-section.patch
mmc-msm_sdccc-driver-for-htc-dream.patch
msm_sdccc-convert-printkkern_level-to-pr_level.patch
msm_sdccc-stylistic-cleaning.patch
msm_sdccc-move-overly-indented-code-to-separate-function.patch
ncpfs-remove-dead-url-from-documentation.patch
maintainers-add-matt-mackall-and-herbert-xu-to-hardware-random-number-generator.patch

