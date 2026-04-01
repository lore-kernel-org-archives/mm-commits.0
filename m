Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D259315D53
	for <mm-commits@vger.kernel.org>; Wed,  1 Apr 2026 17:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775065144; cv=none; b=MMKfCKzIRvK7eAj/CInqBwF94oUtQbA9aSWIXMwjzdGKc/N7OV3WmlC8npE+PkdKL3qEfUNqx9Z4yziiLci+EKjtj+F43p1HTuPHf6/8gicYyQX/bMu9szo2t2Rq3zhdNuXOAjU2Nu68aU+yU/R8FUUum2Z8GkbSK14Zqj1QHQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775065144; c=relaxed/simple;
	bh=XihsbPK80m12BJSSLTSiLFMs1AVMXFoLELe/8NKS10I=;
	h=Date:To:From:Subject:Message-Id; b=G0Lp+sdoSjdHGAClUrLX/TBLE9iO4Z56uUKEKFoTZ4LBpEfoz3j0kClxjlsMLUCFzmLX73PyEZQqprroIlhR+WcQjQVOiEyE3UpeuLXf5K8xm6Toc2ArM/3RsFmLINDaK1Olwy3ZjAADycUUOAR65bqllpCJKHm02euDi3sI4GU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gA7Tm05i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gA7Tm05i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32271C4CEF7;
	Wed,  1 Apr 2026 17:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775065144;
	bh=XihsbPK80m12BJSSLTSiLFMs1AVMXFoLELe/8NKS10I=;
	h=Date:To:From:Subject:From;
	b=gA7Tm05ioRIJx9y7z3T4eYZtnvzBxnhPTORip2P5tBohTcNU91owWjPKF8SDe4FFl
	 U3qRJbIhTne4i91YFexOFj+UHnH5LzKdC0lBVLHcLi4iwaUaWqdSogOpTgG2IghD14
	 EbnDK5+wdtqfxCw1i+339ThZDFRwFexKa90AKV+I=
Date: Wed, 01 Apr 2026 10:39:03 -0700
To: mm-commits@vger.kernel.org,safinaskar@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + get_maintainerignore-add-myself.patch added to mm-nonmm-unstable branch
Message-Id: <20260401173904.32271C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: .get_maintainer.ignore: add myself
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     get_maintainerignore-add-myself.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/get_maintainerignore-add-myself.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Askar Safin <safinaskar@gmail.com>
Subject: .get_maintainer.ignore: add myself
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

get_maintainerignore-add-myself.patch

