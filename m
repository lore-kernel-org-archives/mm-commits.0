From: akpm@linux-foundation.org
Subject: + jbd-fix-missing-kernel-doc.patch added to -mm tree
Date: Tue, 13 Jan 2009 00:40:40 -0800
Message-ID: <200901130840.n0D8eesr001502@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41507 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755255AbZAMIlP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Jan 2009 03:41:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     jbd: fix missing kernel-doc
has been added to the -mm tree.  Its filename is
     jbd-fix-missing-kernel-doc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jbd: fix missing kernel-doc
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix jbd header file kernel-doc notation:

Warning(linux-2.6.28-git13//include/linux/jbd.h:823): No description found for parameter 'j_average_commit_time'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/jbd.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/jbd.h~jbd-fix-missing-kernel-doc include/linux/jbd.h
--- a/include/linux/jbd.h~jbd-fix-missing-kernel-doc
+++ a/include/linux/jbd.h
@@ -614,6 +614,8 @@ struct transaction_s
  * @j_wbufsize: maximum number of buffer_heads allowed in j_wbuf, the
  *	number that will fit in j_blocksize
  * @j_last_sync_writer: most recent pid which did a synchronous write
+ * @j_average_commit_time: the average amount of time in nanoseconds it
+ *	takes to commit a transaction to the disk.
  * @j_private: An opaque pointer to fs-private information.
  */
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

update-of-documentation-vmtxt-and-proctxt.patch
linux-next.patch
kgdb-fix-kernel-doc-error.patch
auditsc-fix-kernel-doc-notation.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
kbuild-fix-kbuildtxt-typos.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
sunrpc-fix-rdma-dependency.patch
proc-move-inode-comment-text-file-to-source-file.patch
esp-fix-section-mismatch-warning.patch
libfc-uses-select-crc32.patch
sysrq-documentation-remove-the-redundant-updated-date.patch
sysrq-documentation-document-why-the-command-header-only-is-shown.patch
sysrq-add-commentary-on-why-we-use-the-console-loglevel-over-using-kern_emerg.patch
jbd-fix-missing-kernel-doc.patch
max3100-spi-uart-driver.patch
linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
pps-parallel-port-clients-support.patch

