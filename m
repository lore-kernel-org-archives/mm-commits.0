Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD5E4F88A
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 23:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IoQmCnqs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8662C433C7;
	Wed, 20 Dec 2023 23:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703113425;
	bh=QmbsIJBW3k39pOg9h5Q4U/mrwoyooSmw55+c84fT/iE=;
	h=Date:To:From:Subject:From;
	b=IoQmCnqsBlnDmnCgs/g74Hs+4zlwfivC9/MtTB9i2WMUjTWiDzIrWur8EjBk2W73X
	 Z3zC7pkXvnFUEMi9Nf6s0fxnpA9bObkVFDSg+fymzsRVE/wTPfqct61vxfWeeoReap
	 GV0AKigVpxihU2/WyGnI56QijydVkD4JgBYQuB3Y=
Date: Wed, 20 Dec 2023 15:03:45 -0800
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,dyoung@redhat.com,bhe@redhat.com,wangjinchao@xfusion.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] crash_core-remove-duplicated-including-of-kexech.patch removed from -mm tree
Message-Id: <20231220230345.D8662C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: crash_core: remove duplicated including of kexec.h
has been removed from the -mm tree.  Its filename was
     crash_core-remove-duplicated-including-of-kexech.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wang Jinchao <wangjinchao@xfusion.com>
Subject: crash_core: remove duplicated including of kexec.h
Date: Fri, 15 Dec 2023 16:54:51 +0800

Remove second include of linux/kexec.h

Link: https://lkml.kernel.org/r/202312151654+0800-wangjinchao@xfusion.com
Signed-off-by: Wang Jinchao <wangjinchao@xfusion.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/crash_core.c |    1 -
 1 file changed, 1 deletion(-)

--- a/kernel/crash_core.c~crash_core-remove-duplicated-including-of-kexech
+++ a/kernel/crash_core.c
@@ -13,7 +13,6 @@
 #include <linux/memory.h>
 #include <linux/cpuhotplug.h>
 #include <linux/memblock.h>
-#include <linux/kexec.h>
 #include <linux/kmemleak.h>
 
 #include <asm/page.h>
_

Patches currently in -mm which might be from wangjinchao@xfusion.com are


