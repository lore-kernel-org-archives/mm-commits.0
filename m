From: akpm@linux-foundation.org
Subject: [folded-merged]
 hfsplus-fixes-worst-case-unicode-to-char-conversion-of-file-names-and-attributes-fix.patch removed from -mm tree
Date: Fri, 06 Jun 2014 14:04:33 -0700
Message-ID: <53922ce1.cQxtPLlkMxrozJky%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40055 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbaFFVEe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jun 2014 17:04:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, sougata@tuxera.com, slava@dubeyko.com, htl10@users.sourceforge.net, hch@infradead.org, anton@tuxera.com, akpm@linux-foundation.org

Subject: [folded-merged] hfsplus-fixes-worst-case-unicode-to-char-conversion-of-file-names-and-attributes-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,anton@tuxera.com,hch@infradead.org,htl10@users.sourceforge.net,slava@dubeyko.com,sougata@tuxera.com,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 06 Jun 2014 14:04:33 -0700


The patch titled
     Subject: hfsplus-fixes-worst-case-unicode-to-char-conversion-of-file-names-and-attributes-fix
has been removed from the -mm tree.  Its filename was
     hfsplus-fixes-worst-case-unicode-to-char-conversion-of-file-names-and-attributes-fix.patch

This patch was dropped because it was folded into hfsplus-fixes-worst-case-unicode-to-char-conversion-of-file-names-and-attributes.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: hfsplus-fixes-worst-case-unicode-to-char-conversion-of-file-names-and-attributes-fix

fix build

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Anton Altaparmakov <anton@tuxera.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>
Cc: Sougata Santra <sougata@tuxera.com>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/xattr.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/hfsplus/xattr.c~hfsplus-fixes-worst-case-unicode-to-char-conversion-of-file-names-and-attributes-fix fs/hfsplus/xattr.c
--- a/fs/hfsplus/xattr.c~hfsplus-fixes-worst-case-unicode-to-char-conversion-of-file-names-and-attributes-fix
+++ a/fs/hfsplus/xattr.c
@@ -726,6 +726,7 @@ ssize_t hfsplus_listxattr(struct dentry
 
 end_listxattr:
 	kfree(strbuf);
+out:
 	hfs_find_exit(&fd);
 	return res;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
rtc-rtc-cmos-drivers-char-rtcc-features-for-decstation-support.patch
rtc-da9063-rtc-driver.patch
hfsplus-fixes-worst-case-unicode-to-char-conversion-of-file-names-and-attributes.patch
hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes-fix.patch
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

