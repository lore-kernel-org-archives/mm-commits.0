From: akpm@linux-foundation.org
Subject: [merged]
 mm-memblock-remove-unnecessary-inclusions-of-bootmemh.patch removed from
 -mm tree
Date: Wed, 22 Jan 2014 12:13:50 -0800
Message-ID: <52e0267e.oxG4Sk5w+T1Zm7o1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54693 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756093AbaAVUNv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:13:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghai@kernel.org, tony@atomide.com, tj@kernel.org, santosh.shilimkar@ti.com, rjw@sisk.pl, pavel@ucw.cz, paul@pwsan.com, mhocko@suse.cz, linux@arm.linux.org.uk, konrad.wilk@oracle.com, kamezawa.hiroyu@jp.fujitsu.com, hpa@zytor.com, hannes@cmpxchg.org, gregkh@linuxfoundation.org, cl@linux-foundation.org, arnd@arndb.de, grygorii.strashko@ti.com

Subject: [merged] mm-memblock-remove-unnecessary-inclusions-of-bootmemh.patch removed from -mm tree
To: grygorii.strashko@ti.com,arnd@arndb.de,cl@linux-foundation.org,gregkh@linuxfoundation.org,hannes@cmpxchg.org,hpa@zytor.com,kamezawa.hiroyu@jp.fujitsu.com,konrad.wilk@oracle.com,linux@arm.linux.org.uk,mhocko@suse.cz,paul@pwsan.com,pavel@ucw.cz,rjw@sisk.pl,santosh.shilimkar@ti.com,tj@kernel.org,tony@atomide.com,yinghai@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:13:50 -0800


The patch titled
     Subject: mm/memblock: remove unnecessary inclusions of bootmem.h
has been removed from the -mm tree.  Its filename was
     mm-memblock-remove-unnecessary-inclusions-of-bootmemh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Grygorii Strashko <grygorii.strashko@ti.com>
Subject: mm/memblock: remove unnecessary inclusions of bootmem.h

Clean-up to remove depedency with bootmem headers.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Reviewed-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Paul Walmsley <paul@pwsan.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Tony Lindgren <tony@atomide.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mem.c  |    1 -
 mm/memory_hotplug.c |    1 -
 2 files changed, 2 deletions(-)

diff -puN drivers/char/mem.c~mm-memblock-remove-unnecessary-inclusions-of-bootmemh drivers/char/mem.c
--- a/drivers/char/mem.c~mm-memblock-remove-unnecessary-inclusions-of-bootmemh
+++ a/drivers/char/mem.c
@@ -22,7 +22,6 @@
 #include <linux/device.h>
 #include <linux/highmem.h>
 #include <linux/backing-dev.h>
-#include <linux/bootmem.h>
 #include <linux/splice.h>
 #include <linux/pfn.h>
 #include <linux/export.h>
diff -puN mm/memory_hotplug.c~mm-memblock-remove-unnecessary-inclusions-of-bootmemh mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memblock-remove-unnecessary-inclusions-of-bootmemh
+++ a/mm/memory_hotplug.c
@@ -9,7 +9,6 @@
 #include <linux/swap.h>
 #include <linux/interrupt.h>
 #include <linux/pagemap.h>
-#include <linux/bootmem.h>
 #include <linux/compiler.h>
 #include <linux/export.h>
 #include <linux/pagevec.h>
_

Patches currently in -mm which might be from grygorii.strashko@ti.com are

origin.patch
mm-nobootmem-free_all_bootmem-again.patch
rtc-rtc-twl-use-devm_-functions.patch
rtc-rtc-vr41xx-use-devm_-functions.patch
linux-next.patch

