From: akpm@linux-foundation.org
Subject: [patch 25/26] MAINTAINERS: add Dan Streetman to zswap maintainers
Date: Tue, 24 Jan 2017 15:18:55 -0800
Message-ID: <5887e0df.F2Z5ICnRiOiXqmlQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41594 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750902AbdAXXS4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jan 2017 18:18:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, ddstreet@ieee.org, sjenning@redhat.com

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
