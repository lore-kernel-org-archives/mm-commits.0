From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-sfi-pattern.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:40:02 -0700
Message-ID: <201103232043.p2NKhcNS028975@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53895 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755141Ab1CWUzH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:55:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: update SFI pattern
has been removed from the -mm tree.  Its filename was
     maintainers-update-sfi-pattern.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: update SFI pattern
From: Joe Perches <joe@perches.com>

commit 937f961a653 ("x86: Move sfi to platform") moved the files, update
the pattern.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-update-sfi-pattern MAINTAINERS
--- a/MAINTAINERS~maintainers-update-sfi-pattern
+++ a/MAINTAINERS
@@ -5657,7 +5657,7 @@ L:	sfi-devel@simplefirmware.org
 W:	http://simplefirmware.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-sfi-2.6.git
 S:	Supported
-F:	arch/x86/kernel/*sfi*
+F:	arch/x86/platform/sfi/
 F:	drivers/sfi/
 F:	include/linux/sfi*.h
 
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch

