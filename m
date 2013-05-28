From: akpm@linux-foundation.org
Subject: [merged] auditfilterc-fix-kernel-doc-warnings.patch removed from
 -mm tree
Date: Tue, 28 May 2013 12:37:05 -0700
Message-ID: <51a50761.kzLScbsGRjVgYZCZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60444 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727Ab3E1ThG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 May 2013 15:37:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, eparis@redhat.com, rdunlap@infradead.org

Subject: [merged] auditfilterc-fix-kernel-doc-warnings.patch removed from -mm tree
To: rdunlap@infradead.org,eparis@redhat.com,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 May 2013 12:37:05 -0700


The patch titled
     Subject: auditfilter.c: fix kernel-doc warnings
has been removed from the -mm tree.  Its filename was
     auditfilterc-fix-kernel-doc-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: auditfilter.c: fix kernel-doc warnings

Fix kernel-doc warnings in kernel/auditfilter.c:

Warning(kernel/auditfilter.c:1029): Excess function parameter 'loginuid' description in 'audit_receive_filter'
Warning(kernel/auditfilter.c:1029): Excess function parameter 'sessionid' description in 'audit_receive_filter'
Warning(kernel/auditfilter.c:1029): Excess function parameter 'sid' description in 'audit_receive_filter'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Eric Paris <eparis@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/auditfilter.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN kernel/auditfilter.c~auditfilterc-fix-kernel-doc-warnings kernel/auditfilter.c
--- a/kernel/auditfilter.c~auditfilterc-fix-kernel-doc-warnings
+++ a/kernel/auditfilter.c
@@ -1021,9 +1021,6 @@ static void audit_log_rule_change(char *
  * @seq: netlink audit message sequence (serial) number
  * @data: payload data
  * @datasz: size of payload data
- * @loginuid: loginuid of sender
- * @sessionid: sessionid for netlink audit message
- * @sid: SE Linux Security ID of sender
  */
 int audit_receive_filter(int type, int pid, int seq, void *data, size_t datasz)
 {
_

Patches currently in -mm which might be from rdunlap@infradead.org are

linux-next.patch
debugging-keep-track-of-page-owners-fix-2.patch

