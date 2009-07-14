From: akpm@linux-foundation.org
Subject: + get_maintainerpl-add-git-min-percent-option-fix.patch added to -mm tree
Date: Tue, 14 Jul 2009 15:32:00 -0700
Message-ID: <200907142232.n6EMW0uS001187@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34594 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754824AbZGNWdE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Jul 2009 18:33:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com


The patch titled
     get_maintainerpl-add-git-min-percent-option-fix
has been added to the -mm tree.  Its filename is
     get_maintainerpl-add-git-min-percent-option-fix.patch

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
Subject: get_maintainerpl-add-git-min-percent-option-fix
From: Joe Perches <joe@perches.com>

Allow an option to control the minimum percentage of sign-offs required
before being considered a maintainer.

git-min-percent has a default value of 5

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/get_maintainer.pl~get_maintainerpl-add-git-min-percent-option-fix scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~get_maintainerpl-add-git-min-percent-option-fix
+++ a/scripts/get_maintainer.pl
@@ -309,7 +309,7 @@ MAINTAINER field selection options:
     --git-chief-penguins => include ${penguin_chiefs}
     --git-min-signatures => number of signatures required (default: 1)
     --git-max-maintainers => maximum maintainers to add (default: 5)
-    --git-min-percent => minimum percentage of commits required (default: 0)
+    --git-min-percent => minimum percentage of commits required (default: 5)
     --git-since => git history to use (default: 1-year-ago)
     --m => include maintainer(s) if any
     --n => include name 'Full Name <addr\@domain.tld>'
_

Patches currently in -mm which might be from joe@perches.com are

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
get_maintainerpl-add-git-min-percent-option-fix.patch

