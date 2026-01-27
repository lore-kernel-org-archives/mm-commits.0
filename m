Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C9152D3A86
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 02:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769482662; cv=none; b=VQxmgncqsBT7iIbaOIe6d5tVbvTXCdLugS+9LNh5XmXOV9qHT7Fued39T4gSdFROUTkNWjwgnisw2IL1hsBTxuU33HMlOrEphBnonn1e+PrY6yuPsH5EUoMMu3IGL+kRDjvr8A8Z/HYAQnpjfueSx9Ck6NwLmjhZgX77gLRUl84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769482662; c=relaxed/simple;
	bh=+YsnFYukajOi6TtOe9xifA15kYQ8B4ANzAzA2eY//No=;
	h=Date:To:From:Subject:Message-Id; b=RO54t02rVsH8FXCQ9mntQtMcwViDTYE8uyimKPnFj7ONZokTE8j+/5UgaQiS4Fri9Rcd8+0qyJqN492+at2Znpt6AsOQhB0cfF+Qji3D1Jtgn2ovZo5FIWMafaCy5atLG8/pI41XI4DxZ1HOU8FQ+e4w6kWv0E+EO1a2UeX4oz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rDj00Kp1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rDj00Kp1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C381CC116C6;
	Tue, 27 Jan 2026 02:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769482661;
	bh=+YsnFYukajOi6TtOe9xifA15kYQ8B4ANzAzA2eY//No=;
	h=Date:To:From:Subject:From;
	b=rDj00Kp1L1xoC5qPs1gfbQus1lxcxD779HxsovOfppqV3AVlyK+9CJC6c4o4djplt
	 Rlk6EifXOSgiXJLzOYg/FdZ43Hix9FgdP+uJnPw9EFPBDAG6R/AnxDkGASHf97mU0K
	 xO9t+Siy5eLnC38bB4AUyBy4iwOJI3ItoXTMqMNQ=
Date: Mon, 26 Jan 2026 18:57:41 -0800
To: mm-commits@vger.kernel.org,akpm@linux-foundation.org,adeep@lexina.in,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-add-entry-for-viacheslav-bocharov.patch removed from -mm tree
Message-Id: <20260127025741.C381CC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: add entry for Viacheslav Bocharov
has been removed from the -mm tree.  Its filename was
     mailmap-add-entry-for-viacheslav-bocharov.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Viacheslav Bocharov <adeep@lexina.in>
Subject: mailmap: add entry for Viacheslav Bocharov
Date: Tue, 20 Jan 2026 11:21:59 +0300

Map my address <adeep@lexina.in> to new personal address <v@baodeep.com>
Old domain lexina.in will no longer be accessible due to registration
expiration.

Link: https://lkml.kernel.org/r/20260120082212.364268-1-adeep@lexina.in
Signed-off-by: Viacheslav Bocharov <adeep@lexina.in>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-add-entry-for-viacheslav-bocharov
+++ a/.mailmap
@@ -850,6 +850,7 @@ Valentin Schneider <vschneid@redhat.com>
 Veera Sundaram Sankaran <quic_veeras@quicinc.com> <veeras@codeaurora.org>
 Veerabhadrarao Badiganti <quic_vbadigan@quicinc.com> <vbadigan@codeaurora.org>
 Venkateswara Naralasetty <quic_vnaralas@quicinc.com> <vnaralas@codeaurora.org>
+Viacheslav Bocharov <v@baodeep.com> <adeep@lexina.in>
 Vikash Garodia <vikash.garodia@oss.qualcomm.com> <vgarodia@codeaurora.org>
 Vikash Garodia <vikash.garodia@oss.qualcomm.com> <quic_vgarodia@quicinc.com>
 Vincent Mailhol <mailhol@kernel.org> <mailhol.vincent@wanadoo.fr>
_

Patches currently in -mm which might be from adeep@lexina.in are


