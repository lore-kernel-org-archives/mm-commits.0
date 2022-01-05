Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61ADCC433EF
	for <mm-commits@archiver.kernel.org>; Wed,  5 Jan 2022 23:27:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245380AbiAEX1H (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Jan 2022 18:27:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245364AbiAEX1H (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jan 2022 18:27:07 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5332C061245
        for <mm-commits@vger.kernel.org>; Wed,  5 Jan 2022 15:27:06 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4JTlxh0H9Nz4xd4;
        Thu,  6 Jan 2022 10:27:04 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1641425225;
        bh=kXMJcxJwAgNFH6a0irvX3M5Zjtt56wx1uuwQ27zHxuU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nrcbmBdEtea/yWzJccKdU+8tV64hiHtzsgN39LJPO9OrA7wcMmbyElwCppe43e22o
         XOPkapLrnOvNAEsMXoSIT+cLzDmeZTvmaVZUncfzegaNc+4R1mPXrRCHQVbbI0nt/9
         1AhzyOTPxjuzma3mdBlZ+CeCTjCBhzGyqYD+L1Mi51cgZ1bi38bKWb2QhwJffqmwoM
         yCyvYUHfF1gcGYSmFJ1xT3H6UKe9mlbQ8kThmQ9vrXGp+g63qGkBbzRj/3KPjfFYU/
         rhpQrvlixx1fHcsgHEJ++m5wAy8t1CFBdUn8TUkHZ6X8ikqhs/LXxFBRbi/KmgwKVl
         Q0g7G+E/1Wgow==
Date:   Thu, 6 Jan 2022 10:27:03 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     akpm@linux-foundation.org
Cc:     hch@lst.de, mm-commits@vger.kernel.org, naresh.kamboju@linaro.org,
        willy@infradead.org
Subject: Re: + mm-simplify-try_to_unuse-fix.patch added to -mm tree
Message-ID: <20220106102703.08e92421@canb.auug.org.au>
In-Reply-To: <20220105231643.6QHtaU4sl%akpm@linux-foundation.org>
References: <20220105231643.6QHtaU4sl%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/dVdHC.AwzYCPH7Yh5SfqY5N";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_/dVdHC.AwzYCPH7Yh5SfqY5N
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Wed, 05 Jan 2022 15:16:43 -0800 akpm@linux-foundation.org wrote:
>
> The patch titled
>      Subject: mm-simplify-try_to_unuse-fix
> has been added to the -mm tree.  Its filename is
>      mm-simplify-try_to_unuse-fix.patch

Added to linux-next today.

--=20
Cheers,
Stephen Rothwell

--Sig_/dVdHC.AwzYCPH7Yh5SfqY5N
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmHWKUcACgkQAVBC80lX
0GzAzAf8DnTJ8CR+QXmgbpv0SBLCOQkyyiuvptH8/zgk8WPffOaQZubJndOd5U7Q
NfgiicRgOhJep7CKo2lWv3sRDciEA6oZz6GFFHoriOJaAHInPZ3hKaj7JdRVI/UW
9flcgIIcIgl3DkQ0RCL7mq1kHIPF9OinP0YIaCa1ZAZHza4WHMT/eydKQY8//Y2G
lafwY1M39WMtk8VzXKJWWaGmp3yK3hx4A9DVpeKPE8ohMIHlXUFgEi5PVFhGf0eC
Qxo+2H2Zxt4kyQx5Y3Cd2JViu2Ar7SDOXSyBPh/xokIB78DXLQ1WCFSAh/UFFRs1
8BPKixagxbMek31zWexklfjljNt9ow==
=OXPy
-----END PGP SIGNATURE-----

--Sig_/dVdHC.AwzYCPH7Yh5SfqY5N--
