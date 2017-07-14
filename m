From: akpm@linux-foundation.org
Subject: [patch 11/13] MAINTAINERS: give kmod some maintainer love
Date: Fri, 14 Jul 2017 14:50:05 -0700
Message-ID: <59693c8d.PoSMEjogMmkxcwfz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55820 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751178AbdGNVuH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jul 2017 17:50:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mcgrof@kernel.org, gregkh@linuxfoundation.org, jeyu@redhat.com, mmarek@suse.com, pmladek@suse.com, rusty@rustcorp.com.au, shuah@kernel.org

From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: MAINTAINERS: give kmod some maintainer love

As suggested by Jessica, I've been actively working on kmod, so
might as well reflect its maintained status.

Changes are expected to go through akpm's tree.

Link: http://lkml.kernel.org/r/20170628223155.26472-2-mcgrof@kernel.org
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
Suggested-by: Jessica Yu <jeyu@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Michal Marek <mmarek@suse.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN MAINTAINERS~maintainers-give-kmod-some-maintainer-love MAINTAINERS
--- a/MAINTAINERS~maintainers-give-kmod-some-maintainer-love
+++ a/MAINTAINERS
@@ -7554,6 +7554,13 @@ F:	include/linux/kmemleak.h
 F:	mm/kmemleak.c
 F:	mm/kmemleak-test.c
 
+KMOD MODULE USERMODE HELPER
+M:	"Luis R. Rodriguez" <mcgrof@kernel.org>
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+F:	kernel/kmod.c
+F:	include/linux/kmod.h
+
 KPROBES
 M:	Ananth N Mavinakayanahalli <ananth@linux.vnet.ibm.com>
 M:	Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
_
