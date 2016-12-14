From: akpm@linux-foundation.org
Subject: [patch 035/114] Kconfig: lib/Kconfig.ubsan fix reference to ubsan documentation
Date: Wed, 14 Dec 2016 15:05:43 -0800
Message-ID: <5851d047.8ztvzPB82lS5Hobf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34656 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933408AbcLNXFo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 18:05:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, andreas.platschek@opentech.at

From: Andreas Platschek <andreas.platschek@opentech.at>
Subject: Kconfig: lib/Kconfig.ubsan fix reference to ubsan documentation

Documenation/ubsan.txt was moved to Documentation/dev-tools/ubsan.rst,
this fixes the reference.

Link: http://lkml.kernel.org/r/1476698152-29340-3-git-send-email-andreas.platschek@opentech.at
Signed-off-by: Andreas Platschek <andreas.platschek@opentech.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.ubsan |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN lib/Kconfig.ubsan~kconfig-lib-kconfigubsan-fix-reference-to-ubsan-documentation lib/Kconfig.ubsan
--- a/lib/Kconfig.ubsan~kconfig-lib-kconfigubsan-fix-reference-to-ubsan-documentation
+++ a/lib/Kconfig.ubsan
@@ -10,7 +10,8 @@ config UBSAN
 	  This option enables undefined behaviour sanity checker
 	  Compile-time instrumentation is used to detect various undefined
 	  behaviours in runtime. Various types of checks may be enabled
-	  via boot parameter ubsan_handle (see: Documentation/ubsan.txt).
+	  via boot parameter ubsan_handle
+	  (see: Documentation/dev-tools/ubsan.rst).
 
 config UBSAN_SANITIZE_ALL
 	bool "Enable instrumentation for the entire kernel"
_
