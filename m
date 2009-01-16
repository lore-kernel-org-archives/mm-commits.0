From: akpm@linux-foundation.org
Subject: [merged] alpha-gitignore-vmlinuxlds.patch removed from -mm tree
Date: Fri, 16 Jan 2009 11:17:44 -0800
Message-ID: <200901161917.n0GJHi82026285@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42521 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936979AbZAPTSG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Jan 2009 14:18:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ink@jurassic.park.msu.ru, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     alpha: .gitignore vmlinux.lds
has been removed from the -mm tree.  Its filename was
     alpha-gitignore-vmlinuxlds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: alpha: .gitignore vmlinux.lds
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/.gitignore |    1 +
 1 file changed, 1 insertion(+)

diff -puN /dev/null arch/alpha/kernel/.gitignore
--- /dev/null
+++ a/arch/alpha/kernel/.gitignore
@@ -0,0 +1 @@
+vmlinux.lds
_

Patches currently in -mm which might be from ink@jurassic.park.msu.ru are

origin.patch
make-sure-nobodys-leaking-resources.patch

