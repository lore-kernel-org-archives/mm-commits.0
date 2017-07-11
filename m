From: akpm@linux-foundation.org
Subject: [merged]
 maintainers-give-proc-sysctl-some-maintainer-love.patch removed from -mm
 tree
Date: Tue, 11 Jul 2017 12:26:17 -0700
Message-ID: <20170711192617.ExaLgzWIi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48416 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932270AbdGKT0S (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2017 15:26:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, mcgrof@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: give proc sysctl some maintainer love
has been removed from the -mm tree.  Its filename was
     maintainers-give-proc-sysctl-some-maintainer-love.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: MAINTAINERS: give proc sysctl some maintainer love

We poke at proc sysctl enough that really we should declare it maintained.
We'll just be Cc'd and sending updates / ACK'ing changes through akpm's
tree.

Link: http://lkml.kernel.org/r/20170524231305.8649-1-mcgrof@kernel.org
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN MAINTAINERS~maintainers-give-proc-sysctl-some-maintainer-love MAINTAINERS
--- a/MAINTAINERS~maintainers-give-proc-sysctl-some-maintainer-love
+++ a/MAINTAINERS
@@ -10559,6 +10559,17 @@ W:	http://wireless.kernel.org/en/users/D
 S:	Obsolete
 F:	drivers/net/wireless/intersil/prism54/
 
+PROC SYSCTL
+M:	"Luis R. Rodriguez" <mcgrof@kernel.org>
+M:	Kees Cook <keescook@chromium.org>
+L:	linux-kernel@vger.kernel.org
+L:	linux-fsdevel@vger.kernel.org
+S:	Maintained
+F:	fs/proc/proc_sysctl.c
+F:	include/linux/sysctl.h
+F:	kernel/sysctl.c
+F:	tools/testing/selftests/sysctl/
+
 PS3 NETWORK SUPPORT
 M:	Geoff Levand <geoff@infradead.org>
 L:	netdev@vger.kernel.org
_

Patches currently in -mm which might be from mcgrof@kernel.org are

sysctl-fix-lax-sysctl_check_table-sanity-check.patch
sysctl-kdocify-sysctl_writes_strict.patch
sysctl-fold-sysctl_writes_strict-checks-into-helper.patch
sysctl-simplify-unsigned-int-support.patch
sysctl-add-unsigned-int-range-support.patch
maintainers-give-kmod-some-maintainer-love.patch
kmod-add-test-driver-to-stress-test-the-module-loader.patch
kmod-throttle-kmod-thread-limit.patch

