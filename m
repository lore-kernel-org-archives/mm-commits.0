From: akpm@linux-foundation.org
Subject: [merged] maintainers-pair-edac-e752x-p-and-m-entries.patch removed from -mm tree
Date: Fri, 29 May 2009 11:42:47 -0700
Message-ID: <200905291842.n4TIglS3011156@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41436 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752710AbZE2Sns (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 May 2009 14:43:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: pair EDAC-E752X P: and M: entries
has been removed from the -mm tree.  Its filename was
     maintainers-pair-edac-e752x-p-and-m-entries.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: pair EDAC-E752X P: and M: entries
From: Joe Perches <joe@perches.com>

Entries should be P: name then M: email address.

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-pair-edac-e752x-p-and-m-entries MAINTAINERS
--- a/MAINTAINERS~maintainers-pair-edac-e752x-p-and-m-entries
+++ a/MAINTAINERS
@@ -1971,8 +1971,8 @@ F:	include/linux/edac.h
 
 EDAC-E752X
 P:	Mark Gross
-P:	Doug Thompson
 M:	mark.gross@intel.com
+P:	Doug Thompson
 M:	dougthompson@xmission.com
 L:	bluesmoke-devel@lists.sourceforge.net (moderated for non-subscribers)
 W:	bluesmoke.sourceforge.net
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
scripts-get_maintainerpl-output-first-field-only-in-mailing-lists-and-after-maintainers.patch
scripts-get_maintainerpl-better-fix-for-subscriber-only-mailing-lists.patch
scripts-get_maintainerpl-improve-git-chief-penquins-linus-torvalds-filtering.patch
scripts-get_maintainerpl-warn-on-missing-git-or-git-repository.patch
scripts-get_maintainerpl-support-m-lines-with-names-and-multiple-entries-per-m-line.patch
scripts-get_maintainerpl-better-email-name-quoting.patch
scripts-get_maintainerpl-support-both-p-m-and-integrated-m-lines.patch
scripts-get_maintainerpl-dont-print-maintainers-when-not-requested.patch
scripts-get_maintainerpl-allow-8-bit-characters-in-email-addresses.patch
scripts-get_maintainerpl-change-die-to-warn-when-command-line-file-is-not-a-patch.patch
maintainers-swap-mismarked-ecrypt-fs-m-and-p-entries.patch
maintainers-add-file-patterns-to-the-rest.patch
maintainers-update-m32r-file-patterns-after-rename.patch
maintainers-mark-alsa-lists-as-moderated.patch
maintainers-remove-l-linux-kernel-vgerkernelorg-from-all-but-the-rest.patch
maintainers-mention-scripts-get_maintainerpl-in-the-preface.patch
maintainers-add-file-pattern-to-cisco-fcoe-hba-driver.patch
maintainers-add-paul-mckenney-to-rcu-and-rcutorture.patch
maintainers-add-file-patterns-to-tty-layer.patch

