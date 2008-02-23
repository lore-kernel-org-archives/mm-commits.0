From: akpm@linux-foundation.org
Subject: + maintainers-ioatdma-dmaengine-and-async_tx-maintainers-change.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:28:44 -0800
Message-ID: <200802230729.m1N7TXrP017907@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:40143 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752136AbYBWH3g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:29:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: maciej.sosnowski@intel.com, dan.j.williams@intel.com, shannon.nelson@intel.com


The patch titled
     MAINTAINERS: ioatdma, dmaengine and async_tx maintainers change
has been added to the -mm tree.  Its filename is
     maintainers-ioatdma-dmaengine-and-async_tx-maintainers-change.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: ioatdma, dmaengine and async_tx maintainers change
From: Maciej Sosnowski <maciej.sosnowski@intel.com>

Shannon Nelson replaced by Maciej Sosnowski in maintanance of INTEL I/OAT
DMA DRIVER, DMA GENERIC ENGINE SUBSYSTEM and ASYNCHRONOUS
TRANSFERS/TRANSFORMS API.

Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN MAINTAINERS~maintainers-ioatdma-dmaengine-and-async_tx-maintainers-change MAINTAINERS
--- a/MAINTAINERS~maintainers-ioatdma-dmaengine-and-async_tx-maintainers-change
+++ a/MAINTAINERS
@@ -640,8 +640,8 @@ S:	Maintained
 ASYNCHRONOUS TRANSFERS/TRANSFORMS API
 P:	Dan Williams
 M:	dan.j.williams@intel.com
-P:	Shannon Nelson
-M:	shannon.nelson@intel.com
+P:	Maciej Sosnowski
+M:	maciej.sosnowski@intel.com
 L:	linux-kernel@vger.kernel.org
 W:	http://sourceforge.net/projects/xscaleiop
 S:	Supported
@@ -1335,8 +1335,8 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 
 DMA GENERIC OFFLOAD ENGINE SUBSYSTEM
-P:	Shannon Nelson
-M:	shannon.nelson@intel.com
+P:	Maciej Sosnowski
+M:	maciej.sosnowski@intel.com
 P:	Dan Williams
 M:	dan.j.williams@intel.com
 L:	linux-kernel@vger.kernel.org
@@ -2014,8 +2014,8 @@ M:	tigran@aivazian.fsnet.co.uk
 S:	Maintained
 
 INTEL I/OAT DMA DRIVER
-P:	Shannon Nelson
-M:	shannon.nelson@intel.com
+P:	Maciej Sosnowski
+M:	maciej.sosnowski@intel.com
 L:	linux-kernel@vger.kernel.org
 S:	Supported
 
_

Patches currently in -mm which might be from maciej.sosnowski@intel.com are

maintainers-ioatdma-dmaengine-and-async_tx-maintainers-change.patch
