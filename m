From: akpm@linux-foundation.org
Subject: [folded-merged]
 hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes-fix.patch removed from -mm tree
Date: Fri, 06 Jun 2014 14:04:54 -0700
Message-ID: <53922cf6.5XUKSe3ifUXLy7Gh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40065 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbaFFVEz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jun 2014 17:04:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, sougata@tuxera.com, slava@dubeyko.com, htl10@users.sourceforge.net, hch@infradead.org, anton@tuxera.com, akpm@linux-foundation.org

Subject: [folded-merged] hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,anton@tuxera.com,hch@infradead.org,htl10@users.sourceforge.net,slava@dubeyko.com,sougata@tuxera.com,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 06 Jun 2014 14:04:54 -0700


The patch titled
     Subject: hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes-fix
has been removed from the -mm tree.  Its filename was
     hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes-fix.patch

This patch was dropped because it was folded into hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes-fix

fix build

fs/hfsplus/xattr_user.c: In function 'hfsplus_user_getxattr':
fs/hfsplus/xattr_user.c:21: error: 'NLS_MAX_CHARSET_SIZE' undeclared (first use in this function)
fs/hfsplus/xattr_user.c:21: error: (Each undeclared identifier is reported only once

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Anton Altaparmakov <anton@tuxera.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>
Cc: Sougata Santra <sougata@tuxera.com>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/xattr_user.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/hfsplus/xattr_user.c~hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes-fix fs/hfsplus/xattr_user.c
--- a/fs/hfsplus/xattr_user.c~hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes-fix
+++ a/fs/hfsplus/xattr_user.c
@@ -6,6 +6,8 @@
  * Handler for user extended attributes.
  */
 
+#include <linux/nls.h>
+
 #include "hfsplus_fs.h"
 #include "xattr.h"
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
rtc-rtc-cmos-drivers-char-rtcc-features-for-decstation-support.patch
rtc-da9063-rtc-driver.patch
hfsplus-fixes-worst-case-unicode-to-char-conversion-of-file-names-and-attributes.patch
hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes.patch
hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes-fix-2.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-fix.patch
sysctl-allow-for-strict-write-position-handling-fix-2.patch
sysctl-allow-for-strict-write-position-handling-fix.patch
sysctl-allow-for-strict-write-position-handling-fix-3.patch
fs-pstore-logging-clean-up-fix.patch
fs-devpts-inodec-convert-printk-to-pr_foo-fix.patch
mm-mark-remap_file_pages-syscall-as-deprecated-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
ufs-sb-mutex-merge-mutex_destroy.patch

