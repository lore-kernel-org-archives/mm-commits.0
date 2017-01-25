From: akpm@linux-foundation.org
Subject: [merged] maintainers-add-dan-streetman-to-zswap-maintainers.patch removed from -mm tree
Date: Wed, 25 Jan 2017 14:05:22 -0800
Message-ID: <58892122.3vXAuy7fTMIhu4Ev%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42198 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752510AbdAYWFX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jan 2017 17:05:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ddstreet@ieee.org, sjenning@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add Dan Streetman to zswap maintainers
has been removed from the -mm tree.  Its filename was
     maintainers-add-dan-streetman-to-zswap-maintainers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Streetman <ddstreet@ieee.org>
Subject: MAINTAINERS: add Dan Streetman to zswap maintainers

Add myself as zswap maintainer.

Link: http://lkml.kernel.org/r/20170124212200.19052-1-ddstreet@ieee.org
Signed-off-by: Dan Streetman <ddstreet@ieee.org>
Acked-by: Seth Jennings <sjenning@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff -puN MAINTAINERS~maintainers-add-dan-streetman-to-zswap-maintainers MAINTAINERS
--- a/MAINTAINERS~maintainers-add-dan-streetman-to-zswap-maintainers
+++ a/MAINTAINERS
@@ -13679,6 +13679,7 @@ F:	Documentation/vm/zsmalloc.txt
 
 ZSWAP COMPRESSED SWAP CACHING
 M:	Seth Jennings <sjenning@redhat.com>
+M:	Dan Streetman <ddstreet@ieee.org>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	mm/zswap.c
_

Patches currently in -mm which might be from ddstreet@ieee.org are

zswap-disable-changing-params-if-init-fails.patch
zswap-allow-initialization-at-boot-without-pool.patch
zswap-clear-compressor-or-zpool-param-if-invalid-at-init.patch

