From: akpm@linux-foundation.org
Subject: [folded-merged]
 debug-more-properly-delay-for-secondary-cpus-fix.patch removed from -mm
 tree
Date: Wed, 14 Dec 2016 14:28:43 -0800
Message-ID: <5851c79b.A4ER2g7EoVfhfJE3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60760 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752488AbcLNW1z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 17:27:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, briannorris@chromium.org, daniel.thompson@linaro.org, dianders@chromium.org, jason.wessel@windriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: debug-more-properly-delay-for-secondary-cpus-fix
has been removed from the -mm tree.  Its filename was
     debug-more-properly-delay-for-secondary-cpus-fix.patch

This patch was dropped because it was folded into debug-more-properly-delay-for-secondary-cpus.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: debug-more-properly-delay-for-secondary-cpus-fix

simplifications, per Daniel

Cc: Brian Norris <briannorris@chromium.org>
Cc: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Douglas Anderson <dianders@chromium.org>
Cc: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/debug/debug_core.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN kernel/debug/debug_core.c~debug-more-properly-delay-for-secondary-cpus-fix kernel/debug/debug_core.c
--- a/kernel/debug/debug_core.c~debug-more-properly-delay-for-secondary-cpus-fix
+++ a/kernel/debug/debug_core.c
@@ -61,8 +61,6 @@
 
 #include "debug_core.h"
 
-#define WAIT_CPUS_STOP_MS	1000
