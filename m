Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0DB357C9F
	for <mm-commits@vger.kernel.org>; Wed, 15 Apr 2026 09:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776244567; cv=none; b=V5u1CcYgk6j13vtJaIGM/T9Fl8Fs9u79L7hNKXGr55YMBljNUvDq8XSywrp5atgKE00PXZvtPkzANrpCIg4j0v7xyz1IvxeaN3GvD+xL4xC3FJHjF+bX0Erk8lNo44scqapmehv7OPXtIh53AJfwb+D3XUwuOOmupd5H4Ux0cng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776244567; c=relaxed/simple;
	bh=GeTm+JxpX6gsypBPG7NV3UntCjAUezJvBJrtHOzPr5k=;
	h=Date:To:From:Subject:Message-Id; b=j4MWwQbgjXk6Lb3Xkru8B9heqIx53Qq+uj7xAJH8IGmm/sd+8MvESEob2X7kSM3rRLNJ2vxcZQ7mjNZ6hviMpZE8khYV0yb4fLfMDLfSGA4vQgIl2BgDeqHz9iDWOZfzVhe/AwcP4VnRkst3EJQLmtqYRCbpYBhmwdUb7D89UQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z161KwK9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z161KwK9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFC84C2BCB4;
	Wed, 15 Apr 2026 09:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776244566;
	bh=GeTm+JxpX6gsypBPG7NV3UntCjAUezJvBJrtHOzPr5k=;
	h=Date:To:From:Subject:From;
	b=Z161KwK9JThP8Ddc35SeRpF86KHv7uOPs/Y9ugPRlUm6+nEQjz9/YOSIwRN7B3N4R
	 pyTUs+VZ+374ris9i2u5jtUkCr9RocYffTc6WizQDNWWkZ2O5ODMihP8Mb3HS6Ld5Z
	 Puhj6iYUbAoH4UZYQZt0ZaDjAAGSomaUt+HGQ6UQ=
Date: Wed, 15 Apr 2026 02:16:02 -0700
To: mm-commits@vger.kernel.org,safinaskar@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] get_maintainerignore-add-myself.patch removed from -mm tree
Message-Id: <20260415091605.DFC84C2BCB4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: .get_maintainer.ignore: add Askar
has been removed from the -mm tree.  Its filename was
     get_maintainerignore-add-myself.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Askar Safin <safinaskar@gmail.com>
Subject: .get_maintainer.ignore: add Askar
Date: Wed, 1 Apr 2026 07:46:19 +0000

I don't want get_maintainer.pl to automatically print my email.

Link: https://lkml.kernel.org/r/20260401074619.988459-1-safinaskar@gmail.com
Signed-off-by: Askar Safin <safinaskar@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .get_maintainer.ignore |    1 +
 1 file changed, 1 insertion(+)

--- a/.get_maintainer.ignore~get_maintainerignore-add-myself
+++ a/.get_maintainer.ignore
@@ -1,6 +1,7 @@
 Alan Cox <alan@lxorguk.ukuu.org.uk>
 Alan Cox <root@hraefn.swansea.linux.org.uk>
 Alyssa Rosenzweig <alyssa@rosenzweig.io>
+Askar Safin <safinaskar@gmail.com>
 Christoph Hellwig <hch@lst.de>
 Jeff Kirsher <jeffrey.t.kirsher@intel.com>
 Marc Gonzalez <marc.w.gonzalez@free.fr>
_

Patches currently in -mm which might be from safinaskar@gmail.com are


