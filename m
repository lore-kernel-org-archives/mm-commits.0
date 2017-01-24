From: akpm@linux-foundation.org
Subject: + maintainers-add-dan-streetman-to-zswap-maintainers.patch added
 to -mm tree
Date: Tue, 24 Jan 2017 13:42:28 -0800
Message-ID: <5887ca44.nawWjrLEz/eXEC0B%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35440 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750785AbdAXVm3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jan 2017 16:42:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ddstreet@ieee.org, sjenning@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add Dan Streetman to zswap maintainers
has been added to the -mm tree.  Its filename is
     maintainers-add-dan-streetman-to-zswap-maintainers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-add-dan-streetman-to-zswap-maintainers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-add-dan-streetman-to-zswap-maintainers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Streetman <ddstreet@ieee.org>
Subject: MAINTAINERS: add Dan Streetman to zswap maintainers

Add myself as zswap maintainer.

Link: http://lkml.kernel.org/r/20170124212200.19052-1-ddstreet@ieee.org
Signed-off-by: Dan Streetman <ddstreet@ieee.org>
Cc: Seth Jennings <sjenning@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff -puN MAINTAINERS~maintainers-add-dan-streetman-to-zswap-maintainers MAINTAINERS
--- a/MAINTAINERS~maintainers-add-dan-streetman-to-zswap-maintainers
+++ a/MAINTAINERS
@@ -13682,6 +13682,7 @@ F:	Documentation/vm/zsmalloc.txt
 
 ZSWAP COMPRESSED SWAP CACHING
 M:	Seth Jennings <sjenning@redhat.com>
+M:	Dan Streetman <ddstreet@ieee.org>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	mm/zswap.c
_

Patches currently in -mm which might be from ddstreet@ieee.org are

maintainers-add-dan-streetman-to-zswap-maintainers.patch
zswap-disable-changing-params-if-init-fails.patch
zswap-allow-initialization-at-boot-without-pool.patch
zswap-clear-compressor-or-zpool-param-if-invalid-at-init.patch

