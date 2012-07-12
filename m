From: akpm@linux-foundation.org
Subject: [merged] mn10300-kernel-internalh-needs-linux-irqreturnh.patch removed from -mm tree
Date: Thu, 12 Jul 2012 12:36:19 -0700
Message-ID: <20120712193619.A31951E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:61889 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932852Ab2GLTgU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jul 2012 15:36:20 -0400
Received: by qabg24 with SMTP id g24so287219qab.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jul 2012 12:36:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, dhowells@redhat.com, yasutake.koichi@jp.panasonic.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mn10300: kernel/internal.h needs <linux/irqreturn.h>
has been removed from the -mm tree.  Its filename was
     mn10300-kernel-internalh-needs-linux-irqreturnh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: mn10300: kernel/internal.h needs <linux/irqreturn.h>

In file included from arch/mn10300/kernel/csrc-mn10300.c:14:0:
arch/mn10300/kernel/internal.h:42:1: error: unknown type name 'irqreturn_t'

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/kernel/internal.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/mn10300/kernel/internal.h~mn10300-kernel-internalh-needs-linux-irqreturnh arch/mn10300/kernel/internal.h
--- a/arch/mn10300/kernel/internal.h~mn10300-kernel-internalh-needs-linux-irqreturnh
+++ a/arch/mn10300/kernel/internal.h
@@ -9,6 +9,8 @@
  * 2 of the Licence, or (at your option) any later version.
  */
 
+#include <linux/irqreturn.h>
+
 struct clocksource;
 struct clock_event_device;
 
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
linux-next.patch
frv-kill-used-but-uninitialized-variable.patch

