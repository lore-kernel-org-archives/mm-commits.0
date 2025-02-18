Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B11528629B
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 22:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739917564; cv=none; b=EOkM5Pccc6CSyFqVxsSm1btd+Tk7Xcn60pjqKTEhKG8OmvKm2UYkm6ZnUkz3BfxApVBs+rA5kF0U+t4/pLLV57aOvbD3iwelvjBYbPDwPe8TEY7Sbg29PYq+08HulhWHGoai0qfql0cA7ONNB0N8e2OlaVlPxoAFAMPT+k7228w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739917564; c=relaxed/simple;
	bh=gAEBPdLEEXmbILo9OpAGCouRU6HykVT47RZDS+h4XsU=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=ok2jf7MvM34KEyMnZlmmY/v5p31BDn1K65IdSyrF0l0881r1vf1lMKr0MpyQ7w/11vZglF0sG/on2NAy21czAB+mtJSlbvp52QU5UFTDuB9JVY93QjT5LmR7H7vqv2GwU1L+oGByUF5ZEN3JCE8TlwALFx8YeGBqpA9/+a5UZ0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J0ZI3h1p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J0ZI3h1p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6FC2C4CEE2;
	Tue, 18 Feb 2025 22:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739917564;
	bh=gAEBPdLEEXmbILo9OpAGCouRU6HykVT47RZDS+h4XsU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=J0ZI3h1prN/DKdTsOQICp9zwGfLAbOMOLziIQY3aDHb/bkMvaK5Xk9jvql9e9x0uy
	 HyiDpnK+7G5WiEAlE4f8k0MUb6hbnVbrAvWMzs/1NIOl/duvTyJ7r6NJ3RliqpdzuL
	 bMO/gMUvYND+vnplTxawZOtbvSbjX83/7MpVujng=
Date: Tue, 18 Feb 2025 14:26:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Suchit K <suchitkarunakaran@gmail.com>
Cc: mm-commits@vger.kernel.org, skhan@linuxfoundation.org
Subject: Re: + documentation-mm-fix-spelling-mistake.patch added to
 mm-unstable branch
Message-Id: <20250218142603.c16ee5bf2148eabb411e9e0e@linux-foundation.org>
In-Reply-To: <CAO9wTFiAphJkat=64R9EmWC+SqQ_ysmyHDVV30E+sHLhYt2_Rg@mail.gmail.com>
References: <20250218042407.5B384C4CEE2@smtp.kernel.org>
	<CAO9wTFiAphJkat=64R9EmWC+SqQ_ysmyHDVV30E+sHLhYt2_Rg@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 18 Feb 2025 14:18:42 +0530 Suchit K <suchitkarunakaran@gmail.com> wrote:

> Hi Andrew, I'm not sure what my next step should be. Should I find the
> original patch message and reply with something specific?

No, no further actions are required.
