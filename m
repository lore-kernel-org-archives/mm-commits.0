Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60371286D60
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752127175; cv=none; b=eVzf7HsMQWVuAlFDwPnNaMbyjcmh9fBVu1DePxGgjenGMb7eyEZ1NwLeDX2LPxEQjkRtSgApzxDhSqVVC28dYMp9fGPGmKJ+v5jqsMaIqYbUUy0FE4fLAjgKmuRP6aGq2zZpgU306i2YUKN6ro1ahsZCW/lV4WNUhqMTWdDbnjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752127175; c=relaxed/simple;
	bh=M2GKosOl/5s7ppDnQB7TljhrARC/mxXXeK+5Zo7bBwA=;
	h=Date:To:From:Subject:Message-Id; b=TUCZVz39QaxVIuAKODYHCaj30M9B9Y2GnW2tnS9WaacHJUsbomQGGLw00HuQY83npD6g0KU1fdsuHPRAps6PJL6xtJ4UviC4XB5h+dXr0Xl/WRRbdCoripQV60hQcvC+3yeQOMbYlLY4ISU/JgvrLwwISlMNQVruC5C7VgBgjqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uVqJKpc8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uVqJKpc8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BF0BC4CEE3;
	Thu, 10 Jul 2025 05:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752127175;
	bh=M2GKosOl/5s7ppDnQB7TljhrARC/mxXXeK+5Zo7bBwA=;
	h=Date:To:From:Subject:From;
	b=uVqJKpc8Ts9S6MeT+mmJ+vOPRZOwYGGm3r+V5a7x2ppiqk3O+OZGvfehB/HGEZwn0
	 cCB8svk3iBn3warpSbKE1GbOxZxyLkC1b2raQbR3g9ckeBOdFXJarXdlXlFWEnGIUp
	 uObC3NU3gT5Y1tihWaxBoOc6X4UE49QTLfElFRUQ=
Date: Wed, 09 Jul 2025 22:59:34 -0700
To: mm-commits@vger.kernel.org,yukuai3@huawei.com,song@kernel.org,herbert@gondor.apana.org.au,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] maintainers-add-lib-raid6-to-software-raid.patch removed from -mm tree
Message-Id: <20250710055935.2BF0BC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add lib/raid6/ to "SOFTWARE RAID"
has been removed from the -mm tree.  Its filename was
     maintainers-add-lib-raid6-to-software-raid.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: MAINTAINERS: add lib/raid6/ to "SOFTWARE RAID"
Date: Thu Jun 19 04:13:17 PM PDT 2025

Cc: Song Liu <song@kernel.org>
Cc: Yu Kuai <yukuai3@huawei.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-lib-raid6-to-software-raid
+++ a/MAINTAINERS
@@ -23053,6 +23053,7 @@ F:	drivers/md/md*
 F:	drivers/md/raid*
 F:	include/linux/raid/
 F:	include/uapi/linux/raid/
+F:	lib/raid6/
 
 SOLIDRUN CLEARFOG SUPPORT
 M:	Russell King <linux@armlinux.org.uk>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mmslub-use-node-notifier-instead-of-memory-notifier-fix.patch
mm-memcg-make-memoryreclaim-interface-generic-fix.patch
introduce-khugepaged_collapse_single_pmd-to-unify-khugepaged-and-madvise_collapse-fix.patch
squashfs-fix-incorrect-argument-to-sizeof-in-kmalloc_array-call-fix.patch

