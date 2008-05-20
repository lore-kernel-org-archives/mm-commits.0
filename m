From: akpm@linux-foundation.org
Subject: + audit-fix-kernel-doc-parameter-notation.patch added to -mm tree
Date: Tue, 20 May 2008 02:09:35 -0700
Message-ID: <200805200909.m4K99Z5e014782@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44126 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757787AbYETJLG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 05:11:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     audit: fix kernel-doc parameter notation
has been added to the -mm tree.  Its filename is
     audit-fix-kernel-doc-parameter-notation.patch

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
Subject: audit: fix kernel-doc parameter notation
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix auditfilter kernel-doc misssing parameter description:

Warning(lin2626-rc3//kernel/auditfilter.c:1551): No description found for parameter 'sessionid'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/auditfilter.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/auditfilter.c~audit-fix-kernel-doc-parameter-notation kernel/auditfilter.c
--- a/kernel/auditfilter.c~audit-fix-kernel-doc-parameter-notation
+++ a/kernel/auditfilter.c
@@ -1544,6 +1544,7 @@ static void audit_log_rule_change(uid_t 
  * @data: payload data
  * @datasz: size of payload data
  * @loginuid: loginuid of sender
+ * @sessionid: sessionid for netlink audit message
  * @sid: SE Linux Security ID of sender
  */
 int audit_receive_filter(int type, int pid, int uid, int seq, void *data,
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
documentation-build-source-files-in-documentation-sub-dir.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
3c515-fix-using-pnp_get_resource-when-config_isapnp=n.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-unionfs.patch
uwb-fix-kconfig-causing-undefined-references.patch
uwb-fix-all-printk-format-warnings.patch
kernel-doc-allow-unnamed-bit-fields.patch
audit-fix-kernel-doc-parameter-notation.patch
scsi-do-not-automatically-select-scsi_dh-for-dm-multipath.patch
flag-parameters-signalfd-fix.patch
flag-parameters-eventfd-fix.patch
bsdacct-stir-up-comments-around-acct_process.patch
profile-likely-unlikely-macros.patch

