Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BCEB2FF675
	for <mm-commits@vger.kernel.org>; Wed, 15 Oct 2025 03:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760497571; cv=none; b=OoMpH7ET2mcrfIUwfW75hHVVx8oztdHcL3lecYLhhaL1QeZZmbtiVTFbZQlrICyterXb+FhxZ8zMBnt8zuOSEteeEtfWeh7tUtclasPHn+n11KKIR0rYQFbZCJBLBypsRYusmuajG9W349NJGWBBuhJDErzZtKdt9QT77wJzYIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760497571; c=relaxed/simple;
	bh=voGdOQem6Hro0AwAHUjbS789//nkdIkIaI6mANppGnY=;
	h=Date:To:From:Subject:Message-Id; b=YgKYNzK7Q0kP0tZlf8LOg8zCwnlp96kcNWV/iO9cYLascU/9mTu4huTlDjTuA1sXr2nuGw4e3FjcvovpJXrlOT9anyD3yNNWvFNNBmO0ibiLT8fCxVrXSavlFMnWiRO3fKQu8pBW8KrcVesu6GUHWoLXwwGhvK634ytPmabkMZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Mf8jmOCi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Mf8jmOCi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74549C4CEF1;
	Wed, 15 Oct 2025 03:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760497569;
	bh=voGdOQem6Hro0AwAHUjbS789//nkdIkIaI6mANppGnY=;
	h=Date:To:From:Subject:From;
	b=Mf8jmOCiNuSqZ9xm5oODuV4VRMRCejVfEzP2fOGt0MqF0Pvg7I12uVsfHyEiP0uNe
	 SsQVKE2hi+aRqSzrySZASLoNr86ouWsFvaMKUcHJSJLbWqFLCRfBvHTUbDutM8sSHY
	 I1kGSNpS2XqAAa8oRBy39HFpPPp0qYotahGjdASM=
Date: Tue, 14 Oct 2025 20:06:08 -0700
To: mm-commits@vger.kernel.org,wangyuli@aosc.io,sln@onemain.com,jarkko@kernel.org,carlos.bilbao@kernel.org,wangyl5933@chinaunicom.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-add-entry-for-wangyuli.patch added to mm-nonmm-unstable branch
Message-Id: <20251015030609.74549C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: .mailmap: Add entry for WangYuli
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mailmap-add-entry-for-wangyuli.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-add-entry-for-wangyuli.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: WangYuli <wangyl5933@chinaunicom.cn>
Subject: .mailmap: Add entry for WangYuli
Date: Tue, 14 Oct 2025 13:07:47 +0800

Map my old, obsolete work email address to my current email address.

My current work email may not be ideal for timely communication, as
it requires a secure network environment for access due to security
policies.

Therefore, associate both my previous and current work email addresses
with an email address provided to me by AOSC Linux community. During
work hours, my commits will likely still be authored using my company
email address.

Link: https://lkml.kernel.org/r/20251014050747.527357-1-wangyuli@aosc.io
Signed-off-by: WangYuli <wangyl5933@chinaunicom.cn>
Signed-off-by: WangYuli <wangyuli@aosc.io>
Cc: Carlos Bilbao <carlos.bilbao@kernel.org>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Shannon Nelson <sln@onemain.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    3 +++
 1 file changed, 3 insertions(+)

--- a/.mailmap~mailmap-add-entry-for-wangyuli
+++ a/.mailmap
@@ -839,6 +839,9 @@ Vivien Didelot <vivien.didelot@gmail.com
 Vlad Dogaru <ddvlad@gmail.com> <vlad.dogaru@intel.com>
 Vladimir Davydov <vdavydov.dev@gmail.com> <vdavydov@parallels.com>
 Vladimir Davydov <vdavydov.dev@gmail.com> <vdavydov@virtuozzo.com>
+WangYuli <wangyuli@aosc.io> <wangyl5933@chinaunicom.cn>
+WangYuli <wangyuli@aosc.io> <wangyuli@deepin.org>
+WangYuli <wangyuli@aosc.io> <wangyuli@uniontech.com>
 Weiwen Hu <huweiwen@linux.alibaba.com> <sehuww@mail.scut.edu.cn>
 WeiXiong Liao <gmpy.liaowx@gmail.com> <liaoweixiong@allwinnertech.com>
 Wen Gong <quic_wgong@quicinc.com> <wgong@codeaurora.org>
_

Patches currently in -mm which might be from wangyl5933@chinaunicom.cn are

mailmap-add-entry-for-wangyuli.patch

