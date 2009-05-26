From: akpm@linux-foundation.org
Subject: + maintainers-swap-mismarked-ecrypt-fs-m-and-p-entries.patch added to -mm tree
Date: Tue, 26 May 2009 14:42:05 -0700
Message-ID: <200905262142.n4QLg5Bk029878@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53659 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758718AbZEZVmg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 May 2009 17:42:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com


The patch titled
     MAINTAINERS: swap mismarked ECRYPT FS M: and P: entries
has been added to the -mm tree.  Its filename is
     maintainers-swap-mismarked-ecrypt-fs-m-and-p-entries.patch

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
Subject: MAINTAINERS: swap mismarked ECRYPT FS M: and P: entries
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~maintainers-swap-mismarked-ecrypt-fs-m-and-p-entries MAINTAINERS
--- a/MAINTAINERS~maintainers-swap-mismarked-ecrypt-fs-m-and-p-entries
+++ a/MAINTAINERS
@@ -1970,8 +1970,8 @@ F:	net/bridge/netfilter/ebt*.c
 ECRYPT FILE SYSTEM
 P:	Tyler Hicks
 M:	tyhicks@linux.vnet.ibm.com
-M:	Dustin Kirkland
-P:	kirkland@canonical.com
+P:	Dustin Kirkland
+M:	kirkland@canonical.com
 L:	ecryptfs-devel@lists.launchpad.net
 W:	https://launchpad.net/ecryptfs
 S:	Supported
_

Patches currently in -mm which might be from joe@perches.com are

maintainers-pair-edac-e752x-p-and-m-entries.patch
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

