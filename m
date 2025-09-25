Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149E82D837E
	for <mm-commits@vger.kernel.org>; Thu, 25 Sep 2025 23:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758841871; cv=none; b=uZBetXq8/PioIArhK7Eb0VUCLpwqI1P677J+CIuyOyMOm966AfRCxrBI2oPSKGzNdK3dKSELJx8NH3end21j8ekiZXCsXwPCuuuxjQ8nnhsku57ar37ueG/ecdsVacTfVTg60Xi/BLr3NvXgiv+LydmgwjBmbu8zpYRYVVmQh88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758841871; c=relaxed/simple;
	bh=vu5mDI7QaFYmBAI/s07+OdAzMM/zAJXIXxE3NheW+h0=;
	h=Date:To:From:Subject:Message-Id; b=fyjc9bh2ls+2FnPw0XF5pimPrrIWyITc66S8UxfIxBL6wAg4lG/JhqPszyOVxuXysT/GFw3liVHiYOjV2SMCQ6/xoXD7/VRondA8rWI7vRGnkes/7hpBnwBpBXkYay7jkJRhabDNVdZJmN77rG02wENdkbQr46MUvGyObPvMsk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rAQS6nnz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rAQS6nnz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91520C4CEF0;
	Thu, 25 Sep 2025 23:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758841870;
	bh=vu5mDI7QaFYmBAI/s07+OdAzMM/zAJXIXxE3NheW+h0=;
	h=Date:To:From:Subject:From;
	b=rAQS6nnz/91i007fulBMtoxce82bmEiR8xMdyyoDOyaez9CXugS1sTXiDjKqQlArB
	 vA5yNwzfQ2XQEltx8uBNY2KYlWEKqYJI1pAGcsCbJerNjX8TNMLPMT6lqjcekByQSM
	 jaX62mzVG8Bg0ICGG5zf37OvYknm5i2BUfPKsxzk=
Date: Thu, 25 Sep 2025 16:11:10 -0700
To: mm-commits@vger.kernel.org,arnd@arndb.de,bence98@sch.bme.hu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-add-entry-for-bence-csokas.patch removed from -mm tree
Message-Id: <20250925231110.91520C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: add entry for Bence Csókás
has been removed from the -mm tree.  Its filename was
     mailmap-add-entry-for-bence-csokas.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Bence Csókás <bence98@sch.bme.hu>
Subject: mailmap: add entry for Bence Csókás
Date: Mon, 15 Sep 2025 11:05:42 +0200
X-Mailer: b4 0.14.2

I will be leaving Prolan this week.  You can reach me by my personal email
for now.

Link: https://lkml.kernel.org/r/20250915-mailmap-v1-1-9ebdea93c6a7@prolan.hu
Signed-off-by: Bence Csókás <bence98@sch.bme.hu>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-add-entry-for-bence-csokas
+++ a/.mailmap
@@ -134,6 +134,7 @@ Ben M Cahill <ben.m.cahill@intel.com>
 Ben Widawsky <bwidawsk@kernel.org> <ben@bwidawsk.net>
 Ben Widawsky <bwidawsk@kernel.org> <ben.widawsky@intel.com>
 Ben Widawsky <bwidawsk@kernel.org> <benjamin.widawsky@intel.com>
+Bence Csókás <bence98@sch.bme.hu> <csokas.bence@prolan.hu>
 Benjamin Poirier <benjamin.poirier@gmail.com> <bpoirier@suse.de>
 Benjamin Tissoires <bentiss@kernel.org> <benjamin.tissoires@gmail.com>
 Benjamin Tissoires <bentiss@kernel.org> <benjamin.tissoires@redhat.com>
_

Patches currently in -mm which might be from bence98@sch.bme.hu are


