Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C6C14B96E
	for <mm-commits@vger.kernel.org>; Wed, 12 Nov 2025 00:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762908585; cv=none; b=mgzYlfPOPWtEBo8Jcd2eyUfhnE79oCjsnpznqDStIi2Ikjr50eo0qw2AKEWoSl0RVR3PU2QQn7+SSeILA8DVgM+eeFoDCntwjBnVhEaCsssec20pEdodq1d1K4haVSZCrhcYDva0Xi78V/Q6oMbRI2Tr21+KwWer8L6BhZAAYaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762908585; c=relaxed/simple;
	bh=xKkwaAgWBdo4HXbd5NXzioWMCxkQnXRnN8QWneaOn+M=;
	h=Date:To:From:Subject:Message-Id; b=Wddm38K7s5Aac42ntti3+XDLd5gW/mnSOk67YKW377W9CmilquEg+mBJJKClyhgEtaTbi4VzApBWDItDy8ZhvA+aeY0PxNWhy0ISEyC26gP+fvQnsUHeIbK3QQqlu+NoByet7Bp/h+uBBwJqtZ4lDKSWWDx6Pn7YJiw9yh8EUAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WLFPaT88; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WLFPaT88"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79AEDC4CEF5;
	Wed, 12 Nov 2025 00:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762908585;
	bh=xKkwaAgWBdo4HXbd5NXzioWMCxkQnXRnN8QWneaOn+M=;
	h=Date:To:From:Subject:From;
	b=WLFPaT88zztCPKLwxIHg74ggqDXcTtSE7Y8xNZDSjOngHJM6P44QMgoCxFN6Pmx8e
	 G3YTYbhKGcBo3iqabG/A5qacHJtMx9ykQfJw7+Fj7uU+Nhf/HGcRaprVnDtnl6PBZR
	 LtFD6zP0s1Ga6X5i0/BJ/3OC5LGhLb4n4NZ9sZkg=
Date: Tue, 11 Nov 2025 16:49:44 -0800
To: mm-commits@vger.kernel.org,wangyuli@aosc.io,sln@onemain.com,jarkko@kernel.org,carlos.bilbao@kernel.org,wangyl5933@chinaunicom.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mailmap-add-entry-for-wangyuli.patch removed from -mm tree
Message-Id: <20251112004945.79AEDC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: .mailmap: add entry for WangYuli
has been removed from the -mm tree.  Its filename was
     mailmap-add-entry-for-wangyuli.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: WangYuli <wangyl5933@chinaunicom.cn>
Subject: .mailmap: add entry for WangYuli
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
@@ -842,6 +842,9 @@ Vivien Didelot <vivien.didelot@gmail.com
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


