From: akpm@linux-foundation.org
Subject: - hpet-clarify-maintainer-entry.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:20:03 -0700
Message-ID: <200807242320.m6ONK3Vo010322@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37784 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751557AbYGXXUd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:20:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clemens@ladisch.de, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     hpet: clarify maintainer entry
has been removed from the -mm tree.  Its filename was
     hpet-clarify-maintainer-entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hpet: clarify maintainer entry
From: Clemens Ladisch <clemens@ladisch.de>

The existing HPET maintainer entries are somewhat unclear about which one
applies to what part of the kernel.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~hpet-clarify-maintainer-entry MAINTAINERS
--- a/MAINTAINERS~hpet-clarify-maintainer-entry
+++ a/MAINTAINERS
@@ -1959,7 +1959,7 @@ P:	Carlos Corbacho
 M:	carlos@strangeworlds.co.uk
 S:	Odd Fixes
 
-HPET:	High Precision Event Timers driver (hpet.c)
+HPET:	High Precision Event Timers driver (drivers/char/hpet.c)
 P:	Clemens Ladisch
 M:	clemens@ladisch.de
 S:	Maintained
_

Patches currently in -mm which might be from clemens@ladisch.de are

origin.patch
if-0-hpet_unregister.patch

