From: akpm@linux-foundation.org
Subject: [alternative-merged]
 of_irqh-fix-build-warnings-when-config_of-is-not-enabled.patch removed from -mm tree
Date: Tue, 17 Sep 2013 14:33:44 -0700
Message-ID: <5238cab8.PMXpwtATe/wOWM8A%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38920 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301Ab3IQVdp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Sep 2013 17:33:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rob.herring@calxeda.com, grant.likely@linaro.org, rdunlap@infradead.org

Subject: [alternative-merged] of_irqh-fix-build-warnings-when-config_of-is-not-enabled.patch removed from -mm tree
To: rdunlap@infradead.org,grant.likely@linaro.org,rob.herring@calxeda.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 17 Sep 2013 14:33:44 -0700


The patch titled
     Subject: of_irq.h: fix build warnings when CONFIG_OF is not enabled
has been removed from the -mm tree.  Its filename was
     of_irqh-fix-build-warnings-when-config_of-is-not-enabled.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: of_irq.h: fix build warnings when CONFIG_OF is not enabled

Fix build warnings when CONFIG_OF is not enabled: (seen on i386 and
x86_64)

include/linux/of_irq.h:82:7: warning: 'struct device_node' declared inside parameter list [enabled by default]
include/linux/of_irq.h:82:7: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]
include/linux/of_irq.h:87:47: warning: 'struct device_node' declared inside parameter list [enabled by default]

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/of_irq.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/of_irq.h~of_irqh-fix-build-warnings-when-config_of-is-not-enabled include/linux/of_irq.h
--- a/include/linux/of_irq.h~of_irqh-fix-build-warnings-when-config_of-is-not-enabled
+++ a/include/linux/of_irq.h
@@ -1,6 +1,8 @@
 #ifndef __OF_IRQ_H
 #define __OF_IRQ_H
 
+struct device_node;
+
 #if defined(CONFIG_OF)
 struct of_irq;
 #include <linux/types.h>
_

Patches currently in -mm which might be from rdunlap@infradead.org are

linux-next.patch
debugging-keep-track-of-page-owners-fix-2.patch

