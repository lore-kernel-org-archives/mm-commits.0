From: akpm@linux-foundation.org
Subject: + maintainers-add-dan-streetman-to-zbud-maintainers.patch added
 to -mm tree
Date: Tue, 24 Jan 2017 14:22:32 -0800
Message-ID: <5887d3a8.XN35pitL3OO0x58N%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38232 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751128AbdAXWWe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jan 2017 17:22:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ddstreet@ieee.org, sjenning@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add Dan Streetman to zbud maintainers
has been added to the -mm tree.  Its filename is
     maintainers-add-dan-streetman-to-zbud-maintainers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-add-dan-streetman-to-zbud-maintainers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-add-dan-streetman-to-zbud-maintainers.patch

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
Subject: MAINTAINERS: add Dan Streetman to zbud maintainers

Add myself as zbud maintainer.

Link: http://lkml.kernel.org/r/20170124221705.26523-1-ddstreet@ieee.org
Signed-off-by: Dan Streetman <ddstreet@ieee.org>
Cc: Seth Jennings <sjenning@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff -puN MAINTAINERS~maintainers-add-dan-streetman-to-zbud-maintainers MAINTAINERS
--- a/MAINTAINERS~maintainers-add-dan-streetman-to-zbud-maintainers
+++ a/MAINTAINERS
@@ -13697,6 +13697,7 @@ F:	drivers/net/hamradio/z8530.h
 
 ZBUD COMPRESSED PAGE ALLOCATOR
 M:	Seth Jennings <sjenning@redhat.com>
+M:	Dan Streetman <ddstreet@ieee.org>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	mm/zbud.c
_

Patches currently in -mm which might be from ddstreet@ieee.org are

maintainers-add-dan-streetman-to-zswap-maintainers.patch
maintainers-add-dan-streetman-to-zbud-maintainers.patch
zswap-disable-changing-params-if-init-fails.patch
zswap-allow-initialization-at-boot-without-pool.patch
zswap-clear-compressor-or-zpool-param-if-invalid-at-init.patch

