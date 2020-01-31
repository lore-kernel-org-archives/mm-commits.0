From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 091/118] thermal: armada: remove unused
 TO_MCELSIUS macro
Date: Thu, 30 Jan 2020 22:16:09 -0800
Message-ID: <20200131061609.Fl0zPHxTi%akpm@linux-foundation.org>
References: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726023AbgAaGQL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 01:16:11 -0500
In-Reply-To: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, akpm@linux-foundation.org, amit.kucheria@verdurent.com, andy.shevchenko@gmail.com, andy@infradead.org, axboe@fb.com, daniel.lezcano@linaro.org, dvhart@infradead.org, emmanuel.grumbach@intel.com, hch@lst.de, jdelvare@suse.com, jic23@kernel.org, johannes.berg@intel.com, Jonathan.Cameron@huawei.com, kbusch@kernel.org, knaack.h@gmx.de, kvalo@codeaurora.org, lars@metafoo.de, linux-mm@kvack.org, linux@roeck-us.net, luciano.coelho@intel.com, mm-commits@vger.kernel.org, pmeerw@pmeerw.net, rui.zhang@intel.com, sagi@grimberg.me, sgruszka@redhat.com, sujith.thomas@intel.com, torvalds@linux-foundation.org

From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: thermal: armada: remove unused TO_MCELSIUS macro

This removes unused TO_MCELSIUS() macro.

Link: http://lkml.kernel.org/r/1576386975-7941-12-git-send-email-akinobu.mita@gmail.com
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Amit Kucheria <amit.kucheria@verdurent.com>
Cc: Andy Shevchenko <andy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Darren Hart <dvhart@infradead.org>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Hartmut Knaack <knaack.h@gmx.de>
Cc: Jean Delvare <jdelvare@suse.com>
Cc: Jens Axboe <axboe@fb.com>
Cc: Johannes Berg <johannes.berg@intel.com>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: Keith Busch <kbusch@kernel.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Luca Coelho <luciano.coelho@intel.com>
Cc: Peter Meerwald-Stadler <pmeerw@pmeerw.net>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Sujith Thomas <sujith.thomas@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/thermal/armada_thermal.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/thermal/armada_thermal.c~thermal-armada-remove-unused-to_mcelsius-macro
+++ a/drivers/thermal/armada_thermal.c
@@ -21,8 +21,6 @@
 
 #include "thermal_core.h"
 
-#define TO_MCELSIUS(c)			((c) * 1000)
