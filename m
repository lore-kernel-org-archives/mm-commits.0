From: akpm@linux-foundation.org
Subject: + maintainers-add-paul-mckenney-to-rcu-and-rcutorture.patch added to -mm tree
Date: Wed, 27 May 2009 14:53:59 -0700
Message-ID: <200905272153.n4RLrx78001929@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34267 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754007AbZE0Vyb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 May 2009 17:54:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, paulmck@linux.vnet.ibm.com


The patch titled
     MAINTAINERS: add Paul McKenney to RCU and RCUTORTURE
has been added to the -mm tree.  Its filename is
     maintainers-add-paul-mckenney-to-rcu-and-rcutorture.patch

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
Subject: MAINTAINERS: add Paul McKenney to RCU and RCUTORTURE
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN MAINTAINERS~maintainers-add-paul-mckenney-to-rcu-and-rcutorture MAINTAINERS
--- a/MAINTAINERS~maintainers-add-paul-mckenney-to-rcu-and-rcutorture
+++ a/MAINTAINERS
@@ -4736,6 +4736,8 @@ F:	drivers/net/wireless/ray*
 RCUTORTURE MODULE
 P:	Josh Triplett
 M:	josh@freedesktop.org
+P:	Paul E. McKenney
+M:	paulmck@linux.vnet.ibm.com
 S:	Maintained
 F:	Documentation/RCU/torture.txt
 F:	kernel/rcutorture.c
@@ -4762,6 +4764,8 @@ F:	net/rds/
 READ-COPY UPDATE (RCU)
 P:	Dipankar Sarma
 M:	dipankar@in.ibm.com
+P:	Paul E. McKenney
+M:	paulmck@linux.vnet.ibm.com
 W:	http://www.rdrop.com/users/paulmck/rclock/
 S:	Supported
 F:	Documentation/RCU/rcu.txt
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
maintainers-add-paul-mckenney-to-rcu-and-rcutorture.patch

