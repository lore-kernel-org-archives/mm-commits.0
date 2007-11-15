From: akpm@linux-foundation.org
Subject: - cris-build-fixes-fix-csum_tcpudp_magic-declaration.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:11:29 -0800
Message-ID: <200711152111.lAFLBTM5015766@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44028 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760059AbXKOVRA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:17:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.nilsson@axis.com, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     cris build fixes: fix csum_tcpudp_magic() declaration
has been removed from the -mm tree.  Its filename was
     cris-build-fixes-fix-csum_tcpudp_magic-declaration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cris build fixes: fix csum_tcpudp_magic() declaration
From: Jesper Nilsson <jesper.nilsson@axis.com>

Remove int from prototype, no longer needed and causes compile error.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
Acked-by: Mikael Starvik <starvik@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-cris/checksum.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-cris/checksum.h~cris-build-fixes-fix-csum_tcpudp_magic-declaration include/asm-cris/checksum.h
--- a/include/asm-cris/checksum.h~cris-build-fixes-fix-csum_tcpudp_magic-declaration
+++ a/include/asm-cris/checksum.h
@@ -62,7 +62,7 @@ static inline __sum16 ip_fast_csum(const
  * returns a 16-bit checksum, already complemented
  */
 
-static inline __sum16 int csum_tcpudp_magic(__be32 saddr, __be32 daddr,
+static inline __sum16 csum_tcpudp_magic(__be32 saddr, __be32 daddr,
 						   unsigned short len,
 						   unsigned short proto,
 						   __wsum sum)
_

Patches currently in -mm which might be from jesper.nilsson@axis.com are

origin.patch
cris-build-fixes-atomich-needs-compilerh.patch
git-mtd.patch
