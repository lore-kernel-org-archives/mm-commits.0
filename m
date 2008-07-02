From: akpm@linux-foundation.org
Subject: - audit-fix-kernel-doc-parameter-notation.patch removed from -mm tree
Date: Wed, 02 Jul 2008 00:47:43 -0700
Message-ID: <200807020747.m627lhd7005674@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58779 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760591AbYGBHsZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 03:48:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, henne@nachtwindheim.de, mm-commits@vger.kernel.org


The patch titled
     audit: fix kernel-doc parameter notation
has been removed from the -mm tree.  Its filename was
     audit-fix-kernel-doc-parameter-notation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: audit: fix kernel-doc parameter notation
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix auditfilter kernel-doc misssing parameter description:

Warning(lin2626-rc3//kernel/auditfilter.c:1551): No description found for parameter 'sessionid'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Henrik Kretzschmar <henne@nachtwindheim.de>
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

origin.patch
doc-kernel-parameterstxt-fix-stale-references.patch
cpusets-document-proc-status-cpus-and-mems-allowed-lists.patch
linux-next.patch
documentation-build-source-files-in-documentation-sub-dir.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
git-kbuild-next.patch
bluetooth-hci_bcsp-fix-bitrev-kconfig.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core-fix.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core-fix-fix.patch
e100-fix-printk-format-warning.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
netfilter-conntrack_helper-needs-to-include-rculisth.patch
git-scsi-misc-fix-scsi_dh-build-errors.patch
lkdtm-fix-for-config_scsi=n.patch
git-unionfs.patch
vmallocinfo-add-numa-information.patch
vmallocinfo-add-numa-information-fix.patch
pm-remove-obsolete-piece-of-pm-documentation-rev-2.patch
flag-parameters-signalfd-fix.patch
flag-parameters-eventfd-fix.patch
kallsyms-unify-32-and-64-bit-code.patch
procfs-guide-drop-pointless-nbsp-entities.patch
bsdacct-stir-up-comments-around-acct_process.patch
documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections.patch
profile-likely-unlikely-macros.patch

