From: akpm@linux-foundation.org
Subject: [merged] maintainers-use-the-correct-efi-stub-location.patch
 removed from -mm tree
Date: Tue, 12 Aug 2014 12:43:07 -0700
Message-ID: <53ea6e4b.5b5ycUlS+P0TL6ZK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f202.google.com ([209.85.192.202]:50044 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754945AbaHLTnI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:43:08 -0400
Received: by mail-pd0-f202.google.com with SMTP id w10so2671728pde.1
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:43:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, roy.franz@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: use the correct efi-stub location
has been removed from the -mm tree.  Its filename was
     maintainers-use-the-correct-efi-stub-location.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: use the correct efi-stub location

Commit 4171fe2f8a47 ("EFI stub documentation updates") moved
the file, update the pattern.

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Roy Franz <roy.franz@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-use-the-correct-efi-stub-location MAINTAINERS
--- a/MAINTAINERS~maintainers-use-the-correct-efi-stub-location
+++ a/MAINTAINERS
@@ -3419,7 +3419,7 @@ M:	Matt Fleming <matt.fleming@intel.com>
 L:	linux-efi@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git
 S:	Maintained
-F:	Documentation/x86/efi-stub.txt
+F:	Documentation/efi-stub.txt
 F:	arch/ia64/kernel/efi.c
 F:	arch/x86/boot/compressed/eboot.[ch]
 F:	arch/x86/include/asm/efi.h
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
fs-isofs-logging-clean-up.patch
linux-next.patch

